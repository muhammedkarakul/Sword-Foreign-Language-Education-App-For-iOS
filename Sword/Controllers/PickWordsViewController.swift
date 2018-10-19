//
//  LearnViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import Koloda
import FirebaseAuth
import FirebaseFirestore
import DeviceKit
import AVFoundation

class PickWordsViewController: CustomMainViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Preferences -
    @IBOutlet var messageLabel: UILabel! // Info message about word choice
    @IBOutlet var kolodaView: KolodaView! // Card stack view
    @IBOutlet weak var learnContainerView: UIView! // When user chose words this view appears
    @IBOutlet weak var titleMessageLabel: UILabel! // Info message about learn screen
    @IBOutlet weak var wordProgressView: UIProgressView! // Progress bar about word learning
    @IBOutlet weak var wordCounterLabel: UILabel! // Which word you are in
    @IBOutlet weak var selectWordContainerView: UIView! // If user wasn't select words this view appears
    @IBOutlet weak var letsLearnContainerView: UIView!
    @IBOutlet weak var selectedWordsTableView: UITableView!
    @IBOutlet weak var letsLearnViewHeaderLabel: UILabel!
    
    
    private let db = Firestore.firestore()
    private var topics = [Topic]()
    private var words = [Word]()
    private var toBeLearnedWords = [Word]()
    private var knownWords = [Word]()
    public var wordsIdArray = [String?]()
    private var numberOfCards: Int = 0
    private var currentCardIndex: Int = 0
    private var isLevelAndTopicsNotSelected: Bool = false
    private var isToBeLearnedWordsSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        getLevelsDataFromFirebaseAndWriteToRealm()
        
        // Do any additional setup after loading the view.
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isLevelAndTopicSelected()
        
        updateView()
    }
    
    private func resetProperties() {
        kolodaView.resetCurrentCardIndex()
        words = [Word]()
        topics = [Topic]()
        wordsIdArray = [String]()
        currentCardIndex = 0
        numberOfCards = 0
        toBeLearnedWords = [Word]()
        knownWords = [Word]()
        isLevelAndTopicsNotSelected = false
        isToBeLearnedWordsSelected = false
    }
    
    private func setupView() {
        
        self.view.addSubview(learnContainerView)
        self.view.addSubview(selectWordContainerView)
        self.view.addSubview(letsLearnContainerView)
        
        learnContainerView.frame = CGRect(x: 8, y: UIApplication.shared.statusBarFrame.height + headerView.height + 16, width: width - 16, height: height - UIApplication.shared.statusBarFrame.height - headerView.height - 66)
        
        selectWordContainerView.frame = CGRect(x: 8, y: UIApplication.shared.statusBarFrame.height + headerView.height + 16, width: width - 16, height: height - UIApplication.shared.statusBarFrame.height - headerView.height - 66)
        
        letsLearnContainerView.frame = CGRect(x: 8, y: UIApplication.shared.statusBarFrame.height + headerView.height + 16, width: width - 16, height: height - UIApplication.shared.statusBarFrame.height - headerView.height - 66)
        
        learnContainerView.alpha = 0.0
        selectWordContainerView.alpha = 0.0
        letsLearnContainerView.alpha = 0.0
        
        learnContainerView.isHidden = true
        selectWordContainerView.isHidden = true
        letsLearnContainerView.isHidden = true
    }
    
    private func updateView() {
        let numberOfCardsToBeSelected = 10
        numberOfCards = self.words.count
        wordCounterLabel.text = "\(currentCardIndex)/\(numberOfCardsToBeSelected)"
        wordProgressView.progress = (Float(currentCardIndex))/Float(numberOfCardsToBeSelected)
        kolodaView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isLevelAndTopicSelected() {
        let currentUser = Utilities.getCurrentUserFromRealm()
        let level = currentUser.getLevel()
        let topics = currentUser.getTopics()
        
        if level != nil && topics != nil {
            if isToBeLearnedWordsSelected {
                changeView(currentView: CurrentView.letsLearnView)
            } else {
                getSelectedTopicsWordsFromRealm()
                changeView(currentView: CurrentView.pickCardsView)
            }
        } else {
            isLevelAndTopicsNotSelected = true
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func selectWordsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "levelAndTopicView", sender: self)
    }
    
    @IBAction func learnButtonTapped(_ sender: CustomButton) {
        print("LEARNBUTTONTAPPED")
        kolodaView.swipe(.left)
    }
    
    @IBAction func knowButtonTapped(_ sender: CustomButton) {
        print("KNOWBUTTONTAPPED")
        kolodaView.swipe(.right)
    }

    @IBAction func goToPreviousWordButtonTapped(_ sender: UIButton) {
        
        kolodaView.revertAction()
        
        if currentCardIndex > 0 {
            currentCardIndex = currentCardIndex - 1
        }
        
        updateView()
    }
    
    @IBAction func changeLevelAndTopicButtonTouchUpInside(_ sender: UIButton) {
        resetProperties()
        performSegue(withIdentifier: "levelAndTopicView", sender: self)
    }
    
    @IBAction func letsLearnButtonTouchUpInside(_ sender: CustomButton) {
        performSegue(withIdentifier: "toBeLearnedWords", sender: self)
    }
    
    // MARK: - Fire Base -
    
    private func getLevelsDataFromFirebaseAndWriteToRealm() {
        // Start activity indicator and disable user interaction with view.
        startActivityIndicator()
        
        db.collection("Level").getDocuments { (querySnapshot, error) in
            
            self.getTopicsDataFromFirebaseAndWriteToRealm()
            
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for level in querySnapshot!.documents {
                    
                    var date = Date()
                    let timestampOptional = level.get("crearedDate") as? Timestamp
                    if let timestamp = timestampOptional {
                        date = timestamp.dateValue()
                    }
                    
                    let tempLevel = Level(
                        id: level.documentID,
                        createdDate: date,
                        name: level.data()["name"] as? String,
                        score: level.data()["score"] as? Int,
                        topics: level.data()["topics"] as? [String]
                    )
                    
                    self.addLevelToRealm(level: tempLevel)
                }
            }
        }
    }
    
    private func getTopicsDataFromFirebaseAndWriteToRealm() {
        // Start activity indicator and disable user interaction with view.
        //startActivityIndicator()
        
        db.collection("Topic").getDocuments { (querySnapshot, error) in
            
            self.getWordsDataFromFirebaseAndWriteToRealm()
            
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for topic in querySnapshot!.documents {
                    
                    var date = Date()
                    let timestampOptional = topic.get("crearedDate") as? Timestamp
                    if let timestamp = timestampOptional {
                        date = timestamp.dateValue()
                    }
                    
                    let tempTopic = Topic(
                        id: topic.documentID,
                        createdDate: date,
                        name: topic.data()["name"] as? String,
                        words: topic.data()["words"] as? [String]
                    )
                    
                    self.addTopicToRealm(topic: tempTopic)
                    
                }
            }
        }
    }
    
    private func getWordsDataFromFirebaseAndWriteToRealm() {
        
        // Start activity indicator and disable user interaction with view.
        //startActivityIndicator()
        
        db.collection("Word").getDocuments { (querySnapshot, error) in
            
            // Stop activity indicator and enable user interaction with view.
            self.stopActivityIndicator()
            
            if self.isLevelAndTopicsNotSelected {
                self.changeView(currentView: CurrentView.pickLevelAndTopicView)
            }
            
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for word in querySnapshot!.documents {
                    
                    var date = Date()
                    let timestampOptional = word.get("crearedDate") as? Timestamp
                    if let timestamp = timestampOptional {
                        date = timestamp.dateValue()
                    }
                    
                    let tempWord = Word(
                        id: word.documentID,
                        foreignLang: word.data()["en"] as? String,
                        motherLang: word.data()["tr"] as? String,
                        createdDate: date,
                        users: word.data()["users"] as? [String]
                    )
                    
                    self.addWordToRealm(word: tempWord)
                    
                }
            }
        }
    }
 
    // MARK: - Get From Realm -
    
    private func getSelectedTopicsWordsFromRealm() {
        let currentUser = Utilities.getCurrentUserFromRealm()
        
        if let topicIds = currentUser.getTopics() {
            for topicId in topicIds {
                if let tempTopic = getTopicDataFromRealmWithID(id: topicId) {
                    if let wordIds = tempTopic.getWords() {
                        for wordId in wordIds {
                            words.append(getWordDataFromRealmWithID(id: wordId)!)
                        }
                    }
                }
            }
        }
        
        updateView()
        
    }
    
    private func getWordDataFromRealmWithID(id: String?) -> Word? {
        var word = Word()
        let realmWords = uiRealm.objects(RealmWord.self)
        for realmWord in realmWords {
            let tempWord = Word(
                id: realmWord.id,
                foreignLang: realmWord.foreignLang,
                motherLang: realmWord.motherLang,
                createdDate: realmWord.createdDate,
                users: realmWord.users?.components(separatedBy: ",")
            )
            
            if tempWord.getId() == id {
                 word = tempWord
            }
        }
        
        return word
    }
    
    private func getTopicDataFromRealmWithID(id: String?) -> Topic? {
        var topic = Topic()
        let realmTopics = uiRealm.objects(RealmTopic.self)
        for realmTopic in realmTopics {
            let tempTopic = Topic(
                id: realmTopic.id,
                createdDate: realmTopic.createdDate,
                name: realmTopic.name,
                words: realmTopic.words?.components(separatedBy: ",")
            )
            
            if tempTopic.getId() == id {
                topic = tempTopic
            }
            
        }
        
        return topic
    }
    
    // MARK: - Add To Realm -
    
    private func addLevelToRealm(level: Level) {
        print("SUCCESS: Level datas added to Realm Database.")
        
        let realmLevel = RealmLevel()
        realmLevel.id = level.getId()
        realmLevel.name = level.getName()
        realmLevel.createdDate = level.getCreatedDate()
        realmLevel.score.value = level.getScore()
        realmLevel.topics = String.arrayToString(stringArray: level.getTopics(), divideBy: ",")
        realmLevel.writeToRealm()
    }
    
    private func addWordToRealm(word: Word) {
        print("SUCCESS: Word datas added to Realm Database.")
        
        let realmWord = RealmWord()
        realmWord.id = word.getId()
        realmWord.foreignLang = word.getForeignLang()
        realmWord.motherLang = word.getMotherLang()
        realmWord.users = String.arrayToString(stringArray: word.getUsers(), divideBy: ",")
        realmWord.writeToRealm()
    }
    
    private func addTopicToRealm(topic: Topic) {
        print("SUCCESS: Topic datas added to Realm Database.")
        
        let realmTopic = RealmTopic()
        realmTopic.id = topic.getId()
        realmTopic.name = topic.getName()
        realmTopic.createdDate = topic.getCreatedDate()
        realmTopic.words = String.arrayToString(stringArray: topic.getWords(), divideBy: ",")
        realmTopic.writeToRealm()
    }
    
    
    // MARK: - Control
    
    public func isWordsSelected() -> Bool{
        if currentCardIndex == 10 {
            return true
        } else {
            return false
        }
    }
    
    // Selected words table view delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toBeLearnedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = UIColor(white: 1.0, alpha: 0.5)
        cell?.textLabel?.text = toBeLearnedWords[indexPath.row].getForeignLang()
        return cell!
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ToBeLearnedWordsViewController {
            
            
            var firstFiveWords = [Word]()
            
            for (index, toBeLearnedWord) in toBeLearnedWords.enumerated() {
                if index < 5 {
                    firstFiveWords.append(toBeLearnedWord)
                }
            }
            
            vc.toBeLearnedWords = firstFiveWords
        }
    }
    
    private func changeViewHiddenState(view: UIView) -> UIView {
        if view.isHidden {
            view.isHidden = false
            UIView.animate(withDuration: 0.2) {
                view.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                view.alpha = 0.0
            }
            view.isHidden = true
        }
        
        return view
    }
    
    public enum CurrentView {
        case pickLevelAndTopicView
        case pickCardsView
        case letsLearnView
    }
    
    public func changeView(currentView: CurrentView) {
        switch currentView {
        case .pickLevelAndTopicView:
            
            selectWordContainerView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.selectWordContainerView.alpha = 1.0
                self.letsLearnContainerView.alpha = 0.0
                self.learnContainerView.alpha = 0.0
            }
            learnContainerView.isHidden = true
            letsLearnContainerView.isHidden = true
            
        case .pickCardsView:
            learnContainerView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.selectWordContainerView.alpha = 0.0
                self.letsLearnContainerView.alpha = 0.0
                self.learnContainerView.alpha = 1.0
            }
            selectWordContainerView.isHidden = true
            letsLearnContainerView.isHidden = true
            
        case .letsLearnView:
            
            letsLearnContainerView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.selectWordContainerView.alpha = 0.0
                self.letsLearnContainerView.alpha = 1.0
                self.learnContainerView.alpha = 0.0
            }
            learnContainerView.isHidden = true
            selectWordContainerView.isHidden = true
        }
    }
    
}

// MARK: - KolodaViewDelegate -

extension PickWordsViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("KARTLAR BİTTİ")
        
        if !isWordsSelected() {
            for word in words {
                if word.getLearnStatus() ?? false {
                    toBeLearnedWords.append(word)
                } else {
                    knownWords.append(word)
                }
            }
            
            if toBeLearnedWords.count < 10 {
                alertWithAction(title: "Bir Hata Oluştu", message: "10 adet kelime seçimi yapmanız gerekiyor.") { (_) in
                    self.resetProperties()
                    self.performSegue(withIdentifier: "levelAndTopicView", sender: self)
                }
            } else {
                letsLearnViewHeaderLabel.text = "Bu günlük \(toBeLearnedWords.count) kelimen hazır."
                selectedWordsTableView.reloadData()
                isToBeLearnedWordsSelected = true
                changeView(currentView: CurrentView.letsLearnView)
            }
        }
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("\(index) INDEXED CARD SELECTED")
        
        let utterance = AVSpeechUtterance(string: words[index].getForeignLang() ?? "")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print("\(index) INDEX CARD SWIPED")
        
        switch direction {
        case .left:
            //toBeLearnedWords.append(words[index])
            words[index].setLearnStatus(learnStatus: true)
            if currentCardIndex < words.count {
                currentCardIndex = currentCardIndex + 1
            }
            //words.remove(at: index)
        case .right:
            //knownWords.append(words[index])
            words[index].setLearnStatus(learnStatus: false)
        default:
            break
        }
        
        if isWordsSelected() {
            
            for word in words {
                if word.getLearnStatus() ?? false {
                    toBeLearnedWords.append(word)
                } else {
                    knownWords.append(word)
                }
            }
            
            if toBeLearnedWords.count < 10 {

                alertWithAction(title: "Bir Hata Oluştu", message: "10 adet kelime seçimi yapmanız gerekiyor.") { (_) in
                    self.resetProperties()
                    self.performSegue(withIdentifier: "levelAndTopicView", sender: self)
                }
                
            } else {
                letsLearnViewHeaderLabel.text = "Bu günlük \(toBeLearnedWords.count) kelimen hazır."
                selectedWordsTableView.reloadData()
                isToBeLearnedWordsSelected = true
                changeView(currentView: CurrentView.letsLearnView)
            }
        
        }
        
        updateView()
        
    }
    
}

// MARK: - KolodaViewDataSource -

extension PickWordsViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return words.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        return setCard(index)
    }
    
    func setCard(_ index: Int) -> UILabel {
        let labelBGColor = UIColor(displayP3Red: (213.0 + CGFloat(index))/255.0, green: (234.0 + CGFloat(index))/255.0, blue: (245.0 + CGFloat(index))/255.0, alpha: 1.0)
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\(words[index].getForeignLang()!)\n\n\(words[index].getMotherLang()!)\n\n"
        label.addImage(imageName: "Sound", afterLabel: true)
        label.backgroundColor = labelBGColor
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 24.0)
        label.layer.borderWidth = 2
        label.layer.borderColor = labelBGColor.cgColor
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
}



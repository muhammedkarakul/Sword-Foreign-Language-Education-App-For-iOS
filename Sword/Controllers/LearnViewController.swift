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

class LearnViewController: CustomMainViewController {
    
    // MARK: - Preferences -
    @IBOutlet var messageLabel: UILabel! // Info message about word choice
    @IBOutlet var kolodaView: KolodaView! // Card stack view
    @IBOutlet weak var learnContainerView: UIView! // When user chose words this view appears
    @IBOutlet weak var titleMessageLabel: UILabel! // Info message about learn screen
    @IBOutlet weak var wordProgressView: UIProgressView! // Progress bar about word learning
    @IBOutlet weak var wordCounterLabel: UILabel! // Which word you are in
    @IBOutlet weak var selectWordContainerView: UIView! // If user wasn't select words this view appears
    
    private let db = Firestore.firestore()
    private var topics = [Topic]()
    private var words = [Word]()
    public var wordsIdArray = [String?]()
    private var numberOfCards: Int = 0
    private var currentCardIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getWordsDataFromFirebaseAndWriteToRealm()
        getTopicsDataFromFirebaseAndWriteToRealm()
        
        isLevelAndTopicSelected()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for word in wordsIdArray {
            print("Word: \(word ?? "no word") getted form Learn View!")
        }
        
        learnContainerView.isHidden = true
        selectWordContainerView.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isLevelAndTopicSelected() {
        let currentUser = getCurrentUserFromRealm()
        let level = currentUser.getLevel()
        let topics = currentUser.getTopics()
        //let userDefaults = UserDefaults.standard
        //if userDefaults.bool(forKey: "isLevelAndTopicsSelected") {
        if level != nil || topics != nil {
            selectWordContainerView.isHidden = true
            learnContainerView.isHidden = false
        } else {
            
            getSelectedTopicsWordsFromRealm()
            
            //selectWordContainerView.isHidden = false
            //learnContainerView.isHidden = true
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func selectWordsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "levelAndTopicView", sender: self)
    }
    
    @IBAction func learnButtonTapped(_ sender: UIButtonWithRoundedCorners) {
        print("LEARNBUTTONTAPPED")
        kolodaView.swipe(.left)
    }
    
    @IBAction func knowButtonTapped(_ sender: UIButtonWithRoundedCorners) {
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
        performSegue(withIdentifier: "levelAndTopicView", sender: self)
    }
    
    // MARK: - Fire Base -
    
    private func getLevelsDataFromFirebaseAndWriteToRealm() {
        // Start activity indicator and disable user interaction with view.
        startActivityIndicator()
        
        db.collection("Level").getDocuments { (querySnapshot, error) in
            
            // Stop activity indicator and enable user interaction with view.
            self.stopActivityIndicator()
            
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
    
    private func getWordsDataFromFirebaseAndWriteToRealm() {
        
        // Start activity indicator and disable user interaction with view.
        startActivityIndicator()
        
        db.collection("Word").getDocuments { (querySnapshot, error) in
            
            // Stop activity indicator and enable user interaction with view.
            self.stopActivityIndicator()
            
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
                
                self.numberOfCards = self.words.count
                
                self.updateView()
                
            }
        }
        
    }
    
    private func getTopicsDataFromFirebaseAndWriteToRealm() {
        // Start activity indicator and disable user interaction with view.
        startActivityIndicator()
        
        db.collection("Topic").getDocuments { (querySnapshot, error) in
            
            // Stop activity indicator and enable user interaction with view.
            self.stopActivityIndicator()
            
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
 
    // MARK: - Get From Realm -
    
    private func getSelectedTopicsWordsFromRealm() {
        let currentUser = getCurrentUserFromRealm()
        
        if let topics = currentUser.getTopics() {
            for topic in topics {
                
            }
        }
        
    }
    
    private func getWordDataFromRealmWithID(id: String?) {
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
                 words.append(tempWord)
            }
        }
    }
    
    
    private func getCurrentUserFromRealm() -> User {
        let realmUsers = uiRealm.objects(RealmUser.self)
        var users = [User]()
        let userDefaults = UserDefaults.standard
        var currentUser = User()
        
        for realmUser in realmUsers {
            var tempUser = User()
            tempUser = User(
                id: realmUser.id,
                name: realmUser.name,
                email: realmUser.email,
                diamond: realmUser.diamond.value,
                createdDate: realmUser.createdDate,
                hearth: realmUser.hearth.value,
                profilePhotoURL: realmUser.profilePhotoURL,
                score: realmUser.score.value,
                level: realmUser.level,
                topics: realmUser.topic?.components(separatedBy: ",")
            )
            
            users.append(tempUser)
        }
        
        for user in users {
            if user.getId() == userDefaults.string(forKey: "uid") {
                currentUser = user
            }
        }
        
        return currentUser
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

}

// MARK: - KolodaViewDelegate -

extension LearnViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("KARTLAR BİTTİ")
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("\(index) INDEXED CARD SELECTED")
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print("\(index) INDEX CARD SWIPED")
        if currentCardIndex < words.count {
            currentCardIndex = currentCardIndex + 1
        }
        updateView()
    }
    
    func updateView() {
        wordCounterLabel.text = "\(currentCardIndex)/\(words.count)"
        wordProgressView.progress = (Float(currentCardIndex))/Float(numberOfCards)
        kolodaView.reloadData()
        
    }
    
}

// MARK: - KolodaViewDataSource -

extension LearnViewController: KolodaViewDataSource {
    
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
        label.text = "\(words[index].getForeignLang()!)\n\n\(words[index].getMotherLang()!)"
        label.backgroundColor = labelBGColor
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
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

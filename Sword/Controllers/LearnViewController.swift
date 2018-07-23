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
    
    private var words = [Word]()
    
    //private let userDefaults = UserDefaults.standard
    
    public var wordsIdArray = [String?]()
    
    private var numberOfCards: Int = 0
    
    // Current card index
    private var currentCardIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        //getCardData()
        
        //self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
//        let headerView = Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?.first as? CustomOverlayView
//        self.view.addSubview(headerView!)
//
//        let device = Device()
//
//        if device == .iPhoneX {
//            // Eğer mobil cihaz iphone x modeli ise üstten 50 pixel boşluk bırak.
//            headerView?.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 50)
//        } else {
//            // Eğer mobil cihaz diğer iphone modelleriyse boşluk bırakmadan headerView'ı konumlandır.
//            headerView?.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 50)
//        }
        
        //let realmUser = RealmUser()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        writeUserDataToRealm()
        
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
    
    private func getCardData() {
        
        // Show activity indicator and disable user interaction with view.
        //self.startActivityIndicator()
        
        db.collection("Word").getDocuments { (querySnapshot, error) in
            
            // Hide activity indicator and transparent background.
            self.stopActivityIndicator()
            
            self.isLevelAndTopicSelected()
            
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for word in querySnapshot!.documents {
                    //print("\(document.documentID) => tr: \(document.data()["tr"]!), en: \(document.data()["en"]!)")
                    let id = word.documentID
                    let foreignLang = word.data()["en"] as? String
                    let motherLang = word.data()["tr"] as? String
                    let createdDate = word.data()["createdDate"] as? Date
                    let users = word.data()["users"] as? [User]
                    
                    let tempWord = Word(id: id, foreignLang: foreignLang, motherLang: motherLang, createdDate: createdDate, users: users)
                    
                    self.words.append(tempWord)
                    
                    
                    
                    self.addWordToRealm(wordToAdd: tempWord)
                    
                }
                
                self.numberOfCards = self.words.count
                
                self.updateView()
                
            }
        }
        
    }
    
    private func addWordToRealm(wordToAdd: Word) {
        print("SUCCESS: Word datas added to Realm Database.")
        
        let realmWord = RealmWord()
        realmWord.id = wordToAdd.getId()
        realmWord.foreignLang = wordToAdd.getForeignLang()
        realmWord.motherLang = wordToAdd.getMotherLang()
        realmWord.writeToRealm()
    }
    
    private func writeUserDataToRealm() {
        
        self.startActivityIndicator()
        
        if let currentUserId = Auth.auth().currentUser?.uid {
            print("CURRENT USER ID: \(currentUserId)")
            let userRef = db.collection("User").document(currentUserId)
            userRef.getDocument { (document, error) in
                
                //self.stopActivityIndicator()
                self.getCardData()
                
                if let doc = document, doc.exists {
                    //let dataDescription = doc.data().map(String.init(describing: )) ?? "nil"
                    let dataDescription = doc.data()
                    print("User data: \(dataDescription!)")
                    if let username = dataDescription!["username"] as? String,
                       let email = dataDescription!["email"] as? String,
                       let photoUrl = dataDescription!["photo_url"] as? String,
                       let hearth = dataDescription!["hearth"] as? Int,
                       let diamond = dataDescription!["diamond"] as? Int,
                       let score = dataDescription!["score"] as? Int,
                       let createdDate = dataDescription!["createdDate"] as? Date,
                       let level = dataDescription!["level"] as? String,
                       let topic = dataDescription!["topic"] as? String {
                        
                        let realmUser = RealmUser()
                        realmUser.id = currentUserId
                        realmUser.name = username
                        realmUser.email = email
                        realmUser.profilePhotoURL = photoUrl
                        realmUser.hearth.value = hearth
                        realmUser.diamond.value = diamond
                        realmUser.score.value = score
                        realmUser.createdDate = createdDate
                        realmUser.level = level
                        realmUser.topic = topic
                        
                        realmUser.writeToRealm()
                        
                        self.learnContainerView.isHidden = false
                        self.getCardData()
                        
                    } else {
                        // User don't pick level and topics show selectWordContainerView.
                        //self.selectWordContainerView.isHidden = false
                    }
                    
                } else {
                    print("User does not exist.")
                }
                
            }
        }
        
        
    }
    
    private func isLevelAndTopicSelected() {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "isLevelAndTopicsSelected") {
            selectWordContainerView.isHidden = true
            learnContainerView.isHidden = false
        } else {
            selectWordContainerView.isHidden = false
            learnContainerView.isHidden = true
        }
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

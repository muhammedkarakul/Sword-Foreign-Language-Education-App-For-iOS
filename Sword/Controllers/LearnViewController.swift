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
    
    let db = Firestore.firestore()
    
    var words = [Word]()
    
    private var numberOfCards: Int = 0
    
    // Current card index
    var currentCardIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        writeUserDataToRealm()
        
        // Do any additional setup after loading the view.
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions -
    
    @IBAction func selectWordsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "LanguageLevelSegue", sender: self)
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
    
    // MARK: - Fire Base -
    
    private func getCardData() {
        
        
        db.collection("Word").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => tr: \(document.data()["tr"]!), en: \(document.data()["en"]!)")
                    let id = document.documentID
                    let foreignLang = document.data()["en"] as? String
                    let motherLang = document.data()["tr"] as? String
                    let createdDate = document.data()["createdDate"] as? Date
                    let users = document.data()["users"] as? [User]
                    
                    let word = Word(id: id, foreignLang: foreignLang, motherLang: motherLang, createdDate: createdDate, users: users)
                    
                    self.words.append(word)
                    
                    let realmWord = RealmWord()
                    realmWord.id = word.getId()
                    realmWord.foreignLang = word.getForeignLang()
                    realmWord.motherLang = word.getMotherLang()
                    
                    self.grabData(wordToAdd: realmWord)
                    
                }
                
                self.numberOfCards = self.words.count
                
                self.updateView()
                
            }
        }
    }
    
    func grabData(wordToAdd: RealmWord) {
        print("SUCCESS: Word datas added to Realm Database.")
        wordToAdd.writeToRealm()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    
     func writeUserDataToRealm() {
         if let currentUserId = Auth.auth().currentUser?.uid {
             print("CURRENT USER ID: \(currentUserId)")
             let userRef = db.collection("User").document(currentUserId)
             userRef.getDocument { (document, error) in
             if let doc = document, doc.exists {
                 //let dataDescription = doc.data().map(String.init(describing: )) ?? "nil"
                 let dataDescription = doc.data()
                 print("Document data: \(dataDescription!)")
                 let username = dataDescription!["username"] as? String
                 let email = dataDescription!["email"] as? String
                 let photoUrl = dataDescription!["photo_url"] as? String
                 let hearth = dataDescription!["hearth"] as? Int
                 let diamond = dataDescription!["diamond"] as? Int
                 let score = dataDescription!["score"] as? Int
                 let createdDate = dataDescription!["createdDate"] as? Date
                 let level = dataDescription!["level"] as? String
                 let topic = dataDescription!["topic"] as? String
                 
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
                
                if level != nil || topic != nil {
                    self.getCardData()
                } else {
                    self.performSegue(withIdentifier: "LanguageLevelSegue", sender: nil)
                }
             
             } else {
                print("Document does not exist.")
             }
             
             }
         }
     }
     
 
    
}

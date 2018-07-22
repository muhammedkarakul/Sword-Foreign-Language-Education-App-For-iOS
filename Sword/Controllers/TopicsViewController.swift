//
//  TopicsViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseFirestore

class TopicsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var submitButton: UIButtonWithRoundedCorners!
    
    @IBOutlet var containerTableView: UITableView!
    
    private var topics = [Topic]()
    
    public var wordsIdArray = [String?]()
    
    private var selectedCellCounter = 0
    
    private var db = Firestore.firestore()
    
    private var wordsArrayString: String?
    
    public var selectedLevel = Level()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerTableView.delegate = self
        containerTableView.dataSource = self
        // Do any additional setup after loading the view.
        //submitButton.isHidden = true
        updateSubmitButtonAppearance()
        
        //getTopicData()
        getTopicDataWithId()
        
        getCurrentUserFromRealm().printUserData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    private func getTopicDataWithId() {
        // Show activity indicator and disable user interaction with view.
        startActivityIndicator()
        
        db.collection("Topic").getDocuments { (snapshot, error) in
            // Stop and hide activity indicator and disable user interaction with view.
            self.stopActivityIndicator()
            
            if let err = error {
                print("Error: \(err)")
            } else {
                for topic in snapshot!.documents {
                    let id = topic.documentID
                    let createdDate = topic.data()["createdDate"] as? Date
                    let name = topic.data()["name"] as? String
                    let words = topic.data()["words"] as! [String?]
                    
                    let tempTopic = Topic(id: id, createdDate: createdDate, name: name, words: words)
                    
                    for id in self.selectedLevel.getTopics() {
                        if tempTopic.getId() == id {
                            self.topics.append(tempTopic)
                        }
                    }
                    
                    self.addTopicToRealm(tempTopic)
                }
                
                self.containerTableView.reloadData()
            }
        }
    }
    
    private func getTopicData() {
        // Show activity indicator and disable user interaction with view.
        startActivityIndicator()
        
        db.collection("Topic").getDocuments { (snapshot, error) in
            
            // Stop and hide activity indicator and disable user interaction with view.
            self.stopActivityIndicator()
            
            if let err = error {
                // if error is not nil(fail) works here.
                print("Error: \(err)")
            } else {
                // if error is nil(success) works here.
                for topic in snapshot!.documents {
                    let id = topic.documentID
                    let createdDate = topic.data()["createdDate"] as? Date
                    let name = topic.data()["name"] as? String
                    let words = topic.data()["words"] as! [String?]
                    self.wordsArrayString = ""
                    
                    let tempTopic = Topic(id: id, createdDate: createdDate, name: name, words: words)
                    
                    self.topics.append(tempTopic)
                    
                    var wordCounter = 0
                    
                    for word in words {
                        
                        wordCounter = wordCounter + 1
                        
                        self.wordsArrayString = self.wordsArrayString! + String(word!)
                        
                        if wordCounter != wordCounter {
                            self.wordsArrayString = self.wordsArrayString! + ","
                        }
                    }
                    
                    self.addTopicToRealm(tempTopic)
                }
                
                self.containerTableView.reloadData()
            }
        }
    }
    
    private func addTopicToRealm(_ topic: Topic) {
        let realmTopic = RealmTopic()
        realmTopic.id = topic.getId()
        realmTopic.createdDate = topic.getCreatedDate()
        realmTopic.name = topic.getName()
        realmTopic.words = ""
        
        realmTopic.writeToRealm()
        
        print("SUCCESS: Topic item added to Realm.")
    }
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIButton) {
        getCurrentUserFromRealm().printUserData()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source And Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
        //return topicIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = topics[indexPath.row].getName()
        //cell?.textLabel?.text = topicIdArray[indexPath.row]
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = UIColor.lightGray
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.white
        selectedCellCounter = selectedCellCounter + 1
        for word in topics[indexPath.row].getWords() {
            wordsIdArray.append(word)
            print("\(word ?? "no word")'s id added to wordIdArray.")
        }
        updateSubmitButtonAppearance()
        print("Selected Level: \(topics[indexPath.row].getName() ?? "no topic selected")")
        //print("Selected Level: \(topicIdArray[indexPath.row] ?? "no topic selected")")
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.lightGray
        selectedCellCounter = selectedCellCounter - 1
        updateSubmitButtonAppearance()
    }
    
    func updateSubmitButtonAppearance() {
        if selectedCellCounter > 0 {
            submitButton.isHidden = false
        } else {
            submitButton.isHidden = true
        }
    }
    
    private func getCurrentUserFromRealm() -> User {
        let realmUsers = uiRealm.objects(RealmUser.self)
        var users = [User]()
        let userDefaults = UserDefaults.standard
        var currentUser = User()
        
        for realmUser in realmUsers {
            var tempUser = User()
            if let id = realmUser.id, let name = realmUser.name, let email = realmUser.email, let diamond = realmUser.diamond.value, let createdDate = realmUser.createdDate, let hearth = realmUser.hearth.value, let profilePhotoURL = realmUser.profilePhotoURL, let score = realmUser.score.value, let level = realmUser.level, let topics = realmUser.topic {
                tempUser = User(
                    id: id,
                    name: name,
                    email: email,
                    diamond: diamond,
                    createdDate: createdDate,
                    hearth: hearth,
                    profilePhotoURL: profilePhotoURL,
                    score: score,
                    level: level,
                    topics: splitStringWithComma(str: topics)  ?? [String]()
                )
            }
           
            users.append(tempUser)
        }
        
        for user in users {
            if user.getId() == userDefaults.string(forKey: "uid") {
                currentUser = user
            }
        }
        
        return currentUser
    }
    
    private func splitStringWithComma(str: String?) -> [String]? {
        var strArray = [String]()
        if let s = str{
            strArray = s.components(separatedBy: ",")
        }
        return strArray
    }
    
    // MARK: - Navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let seg : LearnViewController = segue.destination as? LearnViewController {
        seg.delegate = self
     }
    }
     */
 

}

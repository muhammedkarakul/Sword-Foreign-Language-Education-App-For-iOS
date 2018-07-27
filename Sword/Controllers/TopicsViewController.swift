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
    private var selectedTopics = [Topic]()
    private var selectedCellCounter = 0
    private var db = Firestore.firestore()
    
    public var selectedLevel = Level()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerTableView.delegate = self
        containerTableView.dataSource = self

        updateSubmitButtonAppearance()

        getTopicDataWithId()
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
                    
                    if let topics = self.selectedLevel.getTopics() {
                        for id in topics {
                            if tempTopic.getId() == id {
                                self.topics.append(tempTopic)
                            }
                        }
                    }
                    
                }
                
                self.containerTableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIButton) {
        //getCurrentUserFromRealm().printUserData()
        updateCurrentUserLevelAndTopicDataAndWriteToRealm(user: getCurrentUserFromRealm())
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
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = UIColor.lightGray
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.white
        selectedCellCounter = selectedCellCounter + 1
        updateSubmitButtonAppearance()
        selectedTopics.append(topics[indexPath.row])
        print("Selected Topic: \(topics[indexPath.row].getName() ?? "no topic selected")")
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.lightGray
        selectedCellCounter = selectedCellCounter - 1
        updateSubmitButtonAppearance()
    }
    
    private func updateSubmitButtonAppearance() {
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
    
    private func updateCurrentUserLevelAndTopicDataAndWriteToRealm(user: User) {
        user.setLevel(level: selectedLevel.getId())
        var topicsId = [String]()
        for topic in selectedTopics {
            topicsId.append(topic.getId() ?? "")
        }
        user.setTopic(topics: topicsId)
        
        let tempRealmUser = RealmUser()
        
        tempRealmUser.id = user.getId()
        tempRealmUser.name = user.getName()
        tempRealmUser.email = user.getEmail()
        tempRealmUser.diamond.value = user.getDiamond()
        tempRealmUser.createdDate = user.getCreatedDate()
        tempRealmUser.hearth.value = user.getHearth()
        tempRealmUser.profilePhotoURL = user.getProfilePhotoURL()
        tempRealmUser.score.value = user.getScore()
        tempRealmUser.level = user.getLevel()
        //tempRealmUser.topic = appendStringArrayWithComma(strArray: user.getTopics()!)
        tempRealmUser.topic = String.arrayToString(stringArray: user.getTopics(), divideBy: ",")
        
        tempRealmUser.writeToRealm()
        
        //let userDefaults = UserDefaults.standard
        //userDefaults.set(true, forKey: "isLevelAndTopicsSelected")
        //userDefaults.synchronize()
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

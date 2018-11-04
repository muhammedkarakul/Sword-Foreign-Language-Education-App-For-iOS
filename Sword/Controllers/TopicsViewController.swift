//
//  TopicsViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
//import FirebaseFirestore

class TopicsViewController: CustomViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var submitButton: CustomButton!
    @IBOutlet var containerTableView: UITableView!

    private var topics = [Topic]()
    private var selectedTopics = [Topic]()
    private var selectedTopicIndexes = [Int]()
    private var selectedCellCounter = 0
    //private var db = Firestore.firestore()
    
    public var selectedLevel = Level()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerTableView.delegate = self
        containerTableView.dataSource = self

        //submitButton.isHidden = true
        
        updateSubmitButtonAppearance()

        //getTopicDataWithId()
        
        getTopicsDataFromRealm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    private func getTopicsDataFromRealm() {
        let tempTopics = RealmUtilities.getTopicsFromRealm()
        
        let topicIds = selectedLevel.getTopics()
        
        if let ids = topicIds {
            for id in ids {
                for tempTopic in tempTopics {
                    if id == tempTopic.getId() {
                        topics.append(tempTopic)
                    }
                }
            }
        }
        
    }
    
//    private func getTopicDataWithId() {
//        // Show activity indicator and disable user interaction with view.
//        startActivityIndicator()
//
//        db.collection("Topic").getDocuments { (snapshot, error) in
//            // Stop and hide activity indicator and disable user interaction with view.
//            self.stopActivityIndicator()
//
//            if let err = error {
//                print("Error: \(err)")
//            } else {
//                for topic in snapshot!.documents {
//
//                    var date = Date()
//                    let timestampOptional = topic.get("crearedDate") as? Timestamp
//                    if let timestamp = timestampOptional {
//                        date = timestamp.dateValue()
//                    }
//
//                    let tempTopic = Topic(
//                        id: topic.documentID,
//                        createdDate: date,
//                        name: topic.data()["name"] as? String,
//                        words: topic.data()["words"] as? [String]
//                    )
//
//                    if let topics = self.selectedLevel.getTopics() {
//                        for id in topics {
//                            if tempTopic.getId() == id {
//                                self.topics.append(tempTopic)
//                            }
//                        }
//                    }
//
//                }
//
//                self.containerTableView.reloadData()
//            }
//        }
//    }
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIButton) {
        //getCurrentUserFromRealm().printUserData()
        
        for selectedTopicIndex in selectedTopicIndexes {
            selectedTopics.append(topics[selectedTopicIndex])
        }
        
        updateCurrentUserLevelAndTopicDataAndWriteToRealm(user: RealmUtilities.getCurrentUserFromRealm())
        
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
        cell?.textLabel?.textColor = UIColor(white: 1.0, alpha: 0.5)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor(white: 1.0, alpha: 1.0)
        
        selectedCellCounter += 1
        
        updateSubmitButtonAppearance()
        
        selectedTopicIndexes.append(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor(white: 1.0, alpha: 0.5)
        
        selectedCellCounter -= 1
        
        updateSubmitButtonAppearance()
        
        for (key, selectedTopicIndex) in selectedTopicIndexes.enumerated() {
            if selectedTopicIndex == indexPath.row {
                selectedTopicIndexes.remove(at: key)
            }
        }
        
    }
    
    private func updateSubmitButtonAppearance() {
        if isAnyCellSelected() {
            isSubmitButtonHidden(false)
        } else {
            isSubmitButtonHidden(true)
        }
    }
    
    private func isAnyCellSelected() -> Bool {
        if selectedCellCounter > 0 {
            return true
        } else {
            return false
        }
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
    
    private func isSubmitButtonHidden(_ state: Bool) {
        if state {
            UIView.animate(withDuration: 0.2) {
                self.submitButton.alpha = 0.0
                self.submitButton.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.submitButton.isHidden = false
                self.submitButton.alpha = 1.0
            }
        }
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

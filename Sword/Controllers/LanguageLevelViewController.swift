//
//  LanguageLevelViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LanguageLevelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTableView: UITableView!
    @IBOutlet var submitButton: UIButtonWithRoundedCorners!
    
    // Firebase Firestore Referance
    private let db = Firestore.firestore()
    
    // Level data array.
    private var levels = [Level]()
    
    // Topics array is storing with string type.
    var topicsArrayString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        submitButton.isHidden = true
        
        getLevelData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    private func getLevelData() {
        
        // Show activity indicator and disable user interaction with view.
        startActivityIndicator()
        
        // Level data gets form database.
        db.collection("Level").getDocuments { (snapshot, error) in
            
            // Stop activity indicator and hide, enable user interaction with view.
            self.stopActivityIndicator()
            
            // Check error.
            if let err = error {
                // if error is not nil(fail) works here.
                print("Error: \(err)")
            } else {
                // if error is nil(success) works here.
                
                for level in snapshot!.documents {
                    let id = level.documentID
                    let createdDate = level.data()["createdDate"] as? Date
                    let name = level.data()["name"] as? String
                    let score = level.data()["score"] as? Int
                    let topics = level.data()["topics"] as! [String?]
                    self.topicsArrayString = ""
                    
                    // Create temporary Level object to be add to levels array.
                    let tempLevel = Level(id: id, createdDate: createdDate, name: name, score: score, topics: topics)
                    
                    // Add temporary Level object to levels array's end.
                    self.levels.append(tempLevel)
                    
                    // Count current level's topics.
                    var topicCounter = 0
                    
                    // Append topics to string with comma.
                    for topic in topics {
                        topicCounter = topicCounter + 1
                        
                        self.topicsArrayString = self.topicsArrayString! +  String(topic!)
                        
                        if topicCounter != topics.count {
                            self.topicsArrayString = self.topicsArrayString! + ","
                        }
                    }
                    
                    // Add level datas to Realm.
                    self.addLevelToRealm(tempLevel)
                    
                }
                
                self.contentTableView.reloadData()
            }
        }
    }
    
    // MARK: - Functions
    
    private func addLevelToRealm(_ level: Level) {
        print("SUCCESS: Level item added to Realm.")
        let realmLevel = RealmLevel()
        realmLevel.id = level.getId()
        realmLevel.createdDate = level.getCreatedDate()
        realmLevel.name = level.getName()
        realmLevel.score.value = level.getScore()
        realmLevel.topics = self.topicsArrayString
    }
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIButtonWithRoundedCorners) {
        // Go to topics view
        tabBarController?.selectedIndex = 1
    }
    
    // MARK: - Table View Data Source And Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = levels[indexPath.row].getName()
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = UIColor.lightGray
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.white
        submitButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.lightGray
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

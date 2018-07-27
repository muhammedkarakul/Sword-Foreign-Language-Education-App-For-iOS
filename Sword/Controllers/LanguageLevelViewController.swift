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
    
    private var selectedLevel = Level()
    
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
                // Error is not nil(fail).
                print("Error: \(err)")
            } else {
                // Error is nil(success).
                
                for level in snapshot!.documents {
                    
                    var date = Date()
                    let timestampOptional = level.get("createdDay") as? Timestamp
                    if let timestamp = timestampOptional {
                        date = timestamp.dateValue()
                    }
                    
                    // Create temporary Level object to be add to levels array.
                    let tempLevel = Level(
                        id: level.documentID,
                        createdDate: date,
                        name: level.data()["name"] as? String,
                        score: level.data()["score"] as? Int,
                        topics: level.data()["topics"] as? [String]
                    )
                    
                    // Add temporary Level object to levels array's end.
                    self.levels.append(tempLevel)
                    
                }
                
                self.contentTableView.reloadData()
            }
        }
    }
    
    // MARK: - Functions
    
    private func addLevelToRealm(_ level: Level) {
        let realmLevel = RealmLevel()
        realmLevel.id = level.getId()
        realmLevel.createdDate = level.getCreatedDate()
        realmLevel.name = level.getName()
        realmLevel.score.value = level.getScore()
        realmLevel.topics = self.topicsArrayString
        
        realmLevel.writeToRealm()
        
        print("SUCCESS: Level item added to Realm.")
    }
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIButtonWithRoundedCorners) {
        // Go to topics view
        let topicsViewController = self.tabBarController?.viewControllers![1] as! TopicsViewController
        topicsViewController.selectedLevel = selectedLevel
        //topicsViewController.topicIdArray = topicIdArray
        //topicsViewController.levelName = selectedLevelName
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
        selectedLevel = levels[indexPath.row]
        //topicIdArray = levels[indexPath.row].getTopics()
        //selectedLevelName = levels[indexPath.row].getName()
        //print("Selected Level Topics: \(levels[indexPath.row].getTopics())")
        submitButton.isHidden = false
        //print("Selected Level: \(levels[indexPath.row].getName() ?? "no level selected")")
        
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

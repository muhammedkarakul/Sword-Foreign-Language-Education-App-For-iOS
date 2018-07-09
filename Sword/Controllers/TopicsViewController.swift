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
    
    private var selectedCellCounter = 0
    
    private var db = Firestore.firestore()
    
    private var wordsArrayString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //submitButton.isHidden = true
        updateSubmitButtonAppearance()
        
        getTopicData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
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
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source And Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
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
        print("Selected Level: \(topics[indexPath.row].getName() ?? "no topic selected")")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
    private var selectedTopicIndexes = [Int]()
    private var selectedCellCounter = 0
    
    
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
        
        if let levelId = userDefaults.string(forKey: "Level") {
            
            let selectedLevel = RealmUtilities.getLevel(withId: levelId)
            
            let topicIds = selectedLevel.getTopics()
            
            if let topicIds = topicIds {
                for topicId in topicIds {
                    for tempTopic in tempTopics {
                        if topicId == tempTopic.getId() {
                            topics.append(tempTopic)
                        }
                    }
                }
            }
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        var selectedTopicsIds = [String]()
        
        for selectedTopicIndex in selectedTopicIndexes {
            if let selectedTopicId = topics[selectedTopicIndex].getId() {
                selectedTopicsIds.append(selectedTopicId)
            }
        }
        
        userDefaults.set(selectedTopicsIds, forKey: "Topics")
        
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

}

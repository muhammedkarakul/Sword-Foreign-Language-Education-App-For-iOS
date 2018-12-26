//
//  LanguageLevelViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
//import FirebaseFirestore

class LevelViewController: CustomViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTableView: UITableView!
    @IBOutlet var submitButton: CustomButton!
    
    // Level data array.
    private var levels = [Level]()
    
    private var selectedLevel = Level()
    
    // Topics array is storing with string type.
    var topicsArrayString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        isSubmitButtonHidden(true)
        
        //getLevelData()
        getLevelDataFromRealm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions

    private func getLevelDataFromRealm() {
        levels = RealmUtilities.getLevelsFromRealm()
    }
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: CustomButton) {
        // Go to topics view
        userDefaults.set(selectedLevel.getId(), forKey: "Level")
        
        if let level = userDefaults.object(forKey: "Level") as? String{
            print("Selected Level: \(level)")
        }
        
        
        
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
        cell?.textLabel?.textColor = UIColor(white: 1.0, alpha: 0.5)
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor(white: 1.0, alpha: 1.0)
        selectedLevel = levels[indexPath.row]
        
        isSubmitButtonHidden(false)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor(white: 1.0, alpha: 0.5)
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

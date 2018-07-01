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
    let firestoreReferance = Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        submitButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions -
    
    @IBAction func nextTapped(_ sender: UIButtonWithRoundedCorners) {
        //self.dismiss(animated: true, completion: nil)
        tabBarController?.selectedIndex = 1
    }
    
    // MARK: - Table View Data Source And Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "Cell \(indexPath.row)"
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

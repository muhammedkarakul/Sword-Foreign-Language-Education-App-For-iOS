//
//  DuelResultViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 12.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class GameResultViewController: CustomViewController {
    
    // MARK: - Properties
    @IBOutlet var userLevelLabel: UILabel!
    @IBOutlet var starImageView: UIImageView!
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var gameResultLabel: UILabel!
    @IBOutlet var gainedPointLabel: UILabel!
    @IBOutlet var gainedStoneLabel: UILabel!
    
    private let user = RealmUtilities.getCurrentUserFromRealm()
    
    public var game = Game()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userProfileImageView.image = UIImage(named: "\(user.getProfilePhotoURL() ?? "defaultProfilePhoto-1")")
        userNameLabel.text = user.getName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToMainViewTouchUpInside(_ sender: CustomButton) {
        performSegue(withIdentifier: "mainStoryboardSegue", sender: self)
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

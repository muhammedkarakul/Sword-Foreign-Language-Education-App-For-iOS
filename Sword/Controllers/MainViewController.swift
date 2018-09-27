//
//  MainViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 22.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class MainViewController: CustomViewController {

    // MARK: Preferences -
    
    @IBOutlet var loginWithUserNameButton: UIButtonWithRoundedCorners!
    
    @IBAction func loginWithUserName(_ sender: UIButtonWithRoundedCorners) {
        
        // Go to login with user name view
        performSegue(withIdentifier: "segueLoginWithUserName", sender: self)
    }
    
    @IBAction func loginWithFaceBook(_ sender: UIButtonWithRoundedCorners) {
        
        // Go to login with face book view
        performSegue(withIdentifier: "segueLoginWithFaceBook", sender: self)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        // Go to sign up view
        performSegue(withIdentifier: "segueSignUp", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

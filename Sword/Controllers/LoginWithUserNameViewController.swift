//
//  LoginWithUserNameViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 22.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class LoginWithUserNameViewController: UIViewController, UITextFieldDelegate {
    
    // Preferences
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set textfields delegate to self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     When close button tapped dismiss login view.
     */
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            signInTouchUpInside()
        }
        
        return true
    }
    
    @IBAction func signInTouchUpInside () {
        // Sign in operations.
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let _ = user {
                    print("SIGN IN: SUCCESS")
                    
                    // User is found, go to main screen
                    self.performSegue(withIdentifier: "MainViewSegue", sender: self)
                } else {
                    print("SIGN IN: FAIL")
                    // Error: Check error and show message
                    ProgressHUD.showError(error?.localizedDescription)
                }
            }
        }
        
    }
    
    @IBAction func forgotPasswordTouchUpInside () {
        print("FORGOT BUTTON PRESSED")
        // Go to forgot password view.
        performSegue(withIdentifier: "ForgotPasswordSegue", sender: self)
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

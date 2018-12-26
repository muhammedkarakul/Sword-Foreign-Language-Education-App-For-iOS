//
//  SignUpViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 22.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD
import FirebaseFirestore

class SignUpViewController: CustomViewController, UITextFieldDelegate {
    
    // Properties
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordValidationTextField: UITextField!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordValidationTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordValidationTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            emailTextField.becomeFirstResponder()
        case 2:
            passwordTextField.becomeFirstResponder()
        case 3:
            passwordValidationTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            signUpTouchUpInside()
        }
        
        return true
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpTouchUpInside() {
        
        if  let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let passwordValidation = passwordValidationTextField.text {
            
            let date = Timestamp().dateValue()
            
            if password == passwordValidation {
                
                showBlurView(withBlurEffectStyle: .dark, andCompletion: nil)
                startActivityIndicator()
                
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    
                    self.stopActivityIndicator()
                    self.hideBlurView()
                    
                    if let user = user {
                        print("SUCCESS: USER CREATED")
                        
                        let realmUser = RealmUser()
                        realmUser.initWith(userObject: User(
                            id: user.user.uid,
                            name: name,
                            email: email,
                            diamond: 000,
                            createdDate: date,
                            hearth: 4,
                            profilePhotoURL: nil,
                            score: 0000
                        ))
                        realmUser.writeToRealm()
                        
                    } else {
                        print("ERROR: USER NOT CREATED")
                        ProgressHUD.showError(error?.localizedDescription ?? "Kayıt işlemi yapılamadı. Bilgilerinizi kontrol edip yeniden deneyiniz.")
                    }
                }
                
            } else {
                print("ERROR: NOT SAME PASSWORD FIELDS")
                ProgressHUD.showError("Girdiğiniz şifreler uyuşmuyor. Şifreleri aynı girip tekrar deneyiniz.")
            }
            
            
        } else {
            // When a text field is empty executes here
            print("ERROR: EMPTY FIELDS")
            ProgressHUD.showError("Lütfen tüm alanları eksiksiz doldurup tekrar deneyiniz.")
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

//
//  LoginWithUserNameViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 22.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import ProgressHUD

class LoginWithUserNameViewController: CustomViewController, UITextFieldDelegate {
    
    // Preferences
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    private let db = Firestore.firestore()

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
        
        // Show blur effect.
        showBlurView(withBlurEffectStyle: .dark)
        
        // Start activity indicator and disable user interaction with view.
        startActivityIndicator()
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let u = user {
                    
                    self.getUserDataFromFirebaseWithUserIdAndWriteToRealm(u.user.uid)
                    
                    print("SIGN IN: SUCCESS")
                    
                } else {
                    print("SIGN IN: FAIL")
                    // Error: Check error and show message
                    ProgressHUD.showError(error?.localizedDescription)
                    
                    // Stop activity indicator and enable user interaction with view.
                    self.stopActivityIndicator()
                    
                    // Hide blur effect.
                    self.hideBlurView()
                }
            }
        }
        
    }
    
    @IBAction func forgotPasswordTouchUpInside () {
        print("FORGOT BUTTON PRESSED")
        // Go to forgot password view.
        performSegue(withIdentifier: "ForgotPasswordSegue", sender: self)
    }
    
    private func getUserDataFromFirebaseWithUserIdAndWriteToRealm(_ userId: String?) {
        var currentUser: User?
        
        if let id = userId {
            let userRef = db.collection("User").document(id)
            
            userRef.getDocument { (user, error) in
                
                // Stop activity indicator and enable user interaction with view.
                self.stopActivityIndicator()
                
                // Hide blur effect.
                self.hideBlurView()
                
                if let u = user, user!.exists {
                    let dataDescription = u.data().map(String.init(describing: )) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    var date = Date()
                    let timestampOptional = u.get("crearedDate") as? Timestamp
                    if let timestamp = timestampOptional {
                        date = timestamp.dateValue()
                    }
                    
                    currentUser = User(
                        id: u.documentID,
                        name: u.data()?["username"] as? String,
                        email: u.data()?["email"] as? String,
                        diamond: u.data()?["diamond"] as? Int,
                        createdDate: date,
                        hearth: u.data()?["hearth"] as? Int,
                        profilePhotoURL: u.data()?["photo_url"] as? String,
                        score: u.data()?["score"] as? Int,
                        level: u.data()?["level"] as? String,
                        topics: u.data()?["topic"] as? [String]
                    )
                    
                    currentUser?.printUserData()
                    
                    if let user = currentUser {
                        self.writeUserDataToRealm(user: user)
                    }
                    
                    // Login process completed. Go to Learn Screen.
                    self.performSegue(withIdentifier: "MainViewSegue", sender: self)
                    
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    private func writeUserDataToRealm(user: User) {
        let realmUser = RealmUser()
        realmUser.id = user.getId()
        realmUser.name = user.getName()
        realmUser.email = user.getEmail()
        realmUser.diamond.value = user.getDiamond()
        realmUser.createdDate = user.getCreatedDate()
        realmUser.hearth.value = user.getHearth()
        realmUser.profilePhotoURL = user.getProfilePhotoURL()
        realmUser.score.value = user.getScore()
        realmUser.level = user.getLevel()
        realmUser.topic = String.arrayToString(stringArray: user.getTopics(), divideBy: ",")
        
        realmUser.writeToRealm()
        
        print("USER WROTE TO REALM SUCCESSFULLY")
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

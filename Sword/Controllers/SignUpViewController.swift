//
//  SignUpViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 22.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseAuth
//import FirebaseDatabase
import ProgressHUD
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // Properties
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordValidationTextField: UITextField!
    
    let db = Firestore.firestore()
    
    // Firebase Database Properties
    //var databaseReferance: DatabaseReference?
    //var databaseHandle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordValidationTextField.delegate = self
        
        // Set the firebase referance
        //databaseReferance = Database.database().reference()
        
//        // Create user and listen for changes
//        databaseHandle = databaseReferance?.child("Users").observe(.childAdded, with: { (snapshot) in
//            // Code to execute when a child is added under "Users"
//
//        })
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
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpTouchUpInside() {
        if  let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let passwordValidation = passwordValidationTextField.text {
            
            let timestamp = Timestamp()
            let date = timestamp.dateValue()
            
            let tempUser = User(id: "", name: name, email: email, diamond: 000, createdDate: date, hearth: 4, profilePhotoURL: "Profile_photo_url" , score: 0000, level: "", topics: [String]())
            
            if password == passwordValidation {
                
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let _ = user {
                        print("SUCCESS: USER CREATED")
                        
                        // Save user data to Firebase Firestore Database
                        self.saveUserDataToDatabase(user: tempUser)
                        
                        // Save user data to Firebase Real Time Database
                        //self.saveUserDataToRealTimeDatabase(user: tempUser, id: user?.user.uid)
                        
                        // Save user to Realm local database
                        let realmUser = RealmUser()
                        realmUser.id = user?.user.uid
                        realmUser.name = tempUser.getName()
                        realmUser.email = tempUser.getEmail()
                        realmUser.profilePhotoURL = tempUser.getProfilePhotoURL()
                        realmUser.createdDate = tempUser.getCreatedDate()
                        realmUser.diamond.value = tempUser.getDiamond()
                        realmUser.score.value = tempUser.getScore()
                        realmUser.level = "Beginner"
                        realmUser.topic = "General"
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
    
    /**
     This method saves user data to Firebase Firestore Database.
     - parameter user: The user to be registered to the database.
     */
    private func saveUserDataToDatabase(user: User) {
        
        let docData: [String : Any] = [
            "createdDate" : user.getCreatedDate()!,
            "diamond" : user.getDiamond()!,
            "email" : user.getEmail()!,
            "hearth" : user.getHearth()!,
            "photo_url" : user.getProfilePhotoURL()!,
            "score" : user.getScore()!,
            "username" : user.getName()!
        ]
        
        db.collection("User").document((Auth.auth().currentUser?.uid)!).setData(docData) { error in
            if let err = error {
                print("ERROR: \(err)")
                ProgressHUD.showError(err.localizedDescription)
            } else {
                print("SUCCESS: Document successfully written!")
                self.performSegue(withIdentifier: "MainViewSegue", sender: self)
            }
        }
        
//        db.collection("User").document().setData(docData) { error in
//            if let err = error {
//                print("ERROR: \(err)")
//                ProgressHUD.showError(err.localizedDescription)
//            } else {
//                print("SUCCESS: Document successfully written!")
//                self.performSegue(withIdentifier: "MainViewSegue", sender: self)
//            }
//        }
    }
    
    /**
     This method saves user data to Firebase Realtime Database.
     - parameter id: The ID of the user to be registered in the database.
     - parameter user: The user to be registered to the database.
     */
    
    /*
    private func saveUserDataToRealTimeDatabase(user: User, id: String?) {
        self.databaseReferance?.child("User").child((id)!).setValue(["username" : user.getName()!, "email" : user.getEmail()!, "createdDate" : user.getCreatedDay()!.toMillis(), "diamond" : user.getDiamond()!, "hearth" : user.getHearth()!, "photo" : user.getProfilePhotoURL()!, "score" : user.getScore()!] , withCompletionBlock: { (error, ref) in

            if let e = error {
                print("ERROR: DATA NOT SAVED")
                ProgressHUD.showError(e.localizedDescription)
            } else {
                print("SUCCESS: DATA SAVED")
                self.performSegue(withIdentifier: "MainViewSegue", sender: self)
            }

        })
    }
    */
 
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

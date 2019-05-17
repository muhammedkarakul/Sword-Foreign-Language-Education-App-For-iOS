//
//  MainViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 22.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainViewController: CustomViewController {

    // MARK: Preferences -
    
    private let db = Firestore.firestore()
    
    @IBOutlet var loginWithUserNameButton: CustomButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkUserLogginState()
    }
    
    private func checkUserLogginState() {
        
        // Check if user has already logged in
        if let currentUser = Auth.auth().currentUser {
            // User is signed in.
            print("USER WAS LOGGED IN. GO TO MAIN SCREEN.")
            userDefaults.set(currentUser.uid , forKey: "uid")
            userDefaults.synchronize()
            
            // User was logged in. Update user date and go to Learn Screen.
            getUserDataFromFirebaseWithUserIdAndWriteToRealm(Auth.auth().currentUser?.uid)
            
        }
    }
    
    @IBAction func loginWithUserName(_ sender: CustomButton) {
        
        // Go to login with user name view
        performSegue(withIdentifier: "segueLoginWithUserName", sender: self)
    }
    
    @IBAction func loginWithFaceBook(_ sender: CustomButton) {
        
        // Go to login with face book view
        performSegue(withIdentifier: "segueLoginWithFaceBook", sender: self)
    }
    
    @IBAction func signUp(_ sender: CustomButton) {
        
        // Go to sign up view
        performSegue(withIdentifier: "segueSignUp", sender: self)
    }
    
    // MARK: - Firebase -
    
    private func getUserDataFromFirebaseWithUserIdAndWriteToRealm(_ userId: String?) {
        
        //startActivityIndicator()
        
        if let id = userId {
            let userRef = db!.collection("User").document(id)
            
            userRef.getDocument { (user, error) in
                if let u = user, user!.exists {
                    let dataDescription = u.data().map(String.init(describing: )) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    var date = Date()
                    let timestampOptional = u.get("crearedDate") as? Timestamp
                    if let timestamp = timestampOptional {
                        date = timestamp.dateValue()
                    }
                    
                    let currentUser = User(
                        id: u.documentID,
                        name: u.data()?["username"] as? String,
                        email: u.data()?["email"] as? String,
                        diamond: u.data()?["diamond"] as? Int,
                        createdDate: date,
                        hearth: u.data()?["hearth"] as? Int,
                        profilePhotoURL: u.data()?["photo_url"] as? String,
                        score: u.data()?["score"] as? Int
                        //                        level: u.data()?["level"] as? String,
                        //                        topics: u.data()?["topic"] as? [String]
                    )
                    
                    currentUser.printUserData()
                    
                    self.writeUserDataToRealm(user: currentUser)
                    
                    // User was logged in. Go to Learn Screen.
                    self.performSegue(withIdentifier: "MainViewSegue", sender: self)
                    
                } else {
                    print("Document does not exist")
                    //self.performSegue(withIdentifier: "LoginViewSegue", sender: self)
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
        //        realmUser.level = user.getLevel()
        //        realmUser.topic = String.arrayToString(stringArray: user.getTopics(), divideBy: ",")
        
        realmUser.writeToRealm()
        
        //stopActivityIndicator()
        
        print("USER WROTE TO REALM SUCCESSFULLY")
    }

}

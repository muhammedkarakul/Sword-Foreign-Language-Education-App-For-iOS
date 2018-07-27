//
//  WalkthroughViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 16.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import BWWalkthrough
import FirebaseAuth
import FirebaseFirestore

class WalkthroughViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    private var db: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            showWalkthrough()
            
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        } else {
            
            // Check if user has already logged in
            if Auth.auth().currentUser != nil {
                // User is signed in.
                print("USER WAS LOGGED IN. GO TO MAIN SCREEN.")
                userDefaults.set(Auth.auth().currentUser?.uid , forKey: "uid")
                userDefaults.synchronize()
                // User was logged in. Go to Learn Screen.
                //self.performSegue(withIdentifier: "MainViewSegue", sender: self)
                getUserDataFromFirebaseWithUserIdAndWriteToRealm(Auth.auth().currentUser?.uid)
            } else {
                // No user is signed in.
                print("NO USER WAS LOGGED IN. GO TO LOG IN SCREEN.")
                performSegue(withIdentifier: "LoginViewSegue", sender: self)
            }
            
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showWalkthrough() {
        // Get view controllers and build the walkthrough
        let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = storyboard.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let pageZero = storyboard.instantiateViewController(withIdentifier: "walk0")
        let pageOne = storyboard.instantiateViewController(withIdentifier: "walk1")
        let pageTwo = storyboard.instantiateViewController(withIdentifier: "walk2")
        let pageThree = storyboard.instantiateViewController(withIdentifier: "walk3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController: pageZero)
        walkthrough.add(viewController: pageOne)
        walkthrough.add(viewController: pageTwo)
        walkthrough.add(viewController: pageThree)
        
        self.present(walkthrough, animated: true, completion: nil)
        
    }
    
    // MARK: - Walkthrough Delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Firebase -
    
    private func getUserDataFromFirebaseWithUserIdAndWriteToRealm(_ userId: String?) {
        
        startActivityIndicator()
        
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
                        score: u.data()?["score"] as? Int,
                        level: u.data()?["level"] as? String,
                        topics: u.data()?["topic"] as? [String]
                    )
                    
                    currentUser.printUserData()
                    
                    self.writeUserDataToRealm(user: currentUser)
                    
                    // User was logged in. Go to Learn Screen.
                    self.performSegue(withIdentifier: "MainViewSegue", sender: self)
                    
                } else {
                    print("Document does not exist")
                    self.performSegue(withIdentifier: "LoginViewSegue", sender: self)
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
        
        stopActivityIndicator()
        
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

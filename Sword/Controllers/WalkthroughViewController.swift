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
//import FirebaseFirestore
//import FirebaseDatabase

class WalkthroughViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    //var db: Firestore!
    
    override func viewDidAppear(_ animated: Bool) {
        
        //db = Firestore.firestore()
        
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
                print("USER IS SIGNED IN. GO TO MAIN SCREEN.")
                userDefaults.set(Auth.auth().currentUser?.uid , forKey: "uid")
                userDefaults.synchronize()
                performSegue(withIdentifier: "MainViewSegue", sender: self)
            } else {
                // No user is signed in.
                print("NO USER IS SIGNED IN. GO TO SIGN IN SCREEN.")
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
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

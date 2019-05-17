//
//  WalkthroughViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 16.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import BWWalkthrough
import AVFoundation

class WalkthroughViewController: CustomViewController, BWWalkthroughViewControllerDelegate {
    
    @IBOutlet var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Play splash screen sound.
        playSound(withName: "splash")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Do not remove this function
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func checkWalkthroughPresentState() {
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            showWalkthrough()
            
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        } else {
            
            // No user was loged in.
            print("NO USER WAS LOGGED IN. GO TO LOG IN SCREEN.")
            performSegue(withIdentifier: "LoginViewSegue", sender: self)
            
            
            /*
            // Check if user has already logged in
            if let currentUser = Auth.auth().currentUser {
                // User is signed in.
                print("USER WAS LOGGED IN. GO TO MAIN SCREEN.")
                userDefaults.set(currentUser.uid , forKey: "uid")
                userDefaults.synchronize()
                
                // User was logged in. Update user date and go to Learn Screen.
                getUserDataFromFirebaseWithUserIdAndWriteToRealm(Auth.auth().currentUser?.uid)
                
            } else {
                // No user is signed in.
                print("NO USER WAS LOGGED IN. GO TO LOG IN SCREEN.")
                performSegue(withIdentifier: "LoginViewSegue", sender: self)
            }
 */
        }
    }
    
    private func showWalkthrough() {
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
        self.dismiss(animated: true) {
            self.checkWalkthroughPresentState()
        }
    }
 
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
//        UIView.animate(withDuration: 0.5) {
//            self.iconImageView.alpha = 0.0
//        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.iconImageView.alpha = 0.0
        }) { _ in
            self.checkWalkthroughPresentState()
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

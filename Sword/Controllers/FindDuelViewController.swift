//
//  FindDuelViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 12.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseFunctions

class FindDuelViewController: UIViewController {
    
    // MARK: - Properties
    
    // Current User
    var user = User()
    
    // Timer
    var timer = Timer()
    
    // Keeps opponent finding timer interval
    var timeInterval = 0
    
    // User
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userLevelLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    
    // Opponent
    @IBOutlet var opponentImageView: UIImageView!
    @IBOutlet var opponentLevelLabel: UILabel!
    @IBOutlet var opponentNameLabel: UILabel!
    
    // Status Label
    @IBOutlet var statusLabel: UILabel!
    
    // Firebase function
    lazy var functions = Functions.functions()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get current user.
        user = Utilities.getCurrentUserFromRealm()

        // Setup view.
        setupView()
        
        // Find a opponent and go to duel view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Find opponent again.
        self.findOpponent()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            
            // Increase time interval every seconds
            self.timeInterval += 1
            
            // Find opponent
            self.findOpponent()
            
            
            if self.timeInterval == 10 {
                self.alertWithOkAndCancelAction(title: "Rakip Bulunamadı", message: "Şu anda düllo yapabileceğiniz bir kullanıcı bulunamadı. Tekrar denemek ister misiniz?", okButtonTitle: "Tekrar Dene", cancelButtonTitle: "Hayır", okButtonHandler: { (_) in
                    
                }, cancelButtonHandler: { (_) in
                    
                    // Go to main view.
                    self.performSegue(withIdentifier: "mainViewSegue", sender: self)
                })
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        
        if let userImageUrl = user.getProfilePhotoURL() {
            userImageView.image = UIImage(named: userImageUrl)
        }
        
        if let userLevel = user.getLevel() {
            userLevelLabel.text = userLevel
        }
        
        if let userName = user.getName() {
            userNameLabel.text = userName
        }
        
    }
    
    private func findOpponent() {
        
        functions.httpsCallable("helloWorlds").call("duel") { (result, error) in
            
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    
                    if let code = code {
                        print("Code: \(code)")
                    }
                    
                    print("Message: \(message)")
                    
                    if let details = details {
                        print("Details: \(details)")
                    }
                    
                }
                
            }

            if let text = (result?.data as? [String: Any])?["text"] as? String {
                print("Result: \(text)")
                self.timer.invalidate()
            }
        }
    }

}

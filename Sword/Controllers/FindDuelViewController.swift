//
//  FindDuelViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 12.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseFirestore

class FindDuelViewController: UIViewController {
    
    // MARK: - Properties
    
    // Game object
    private var game: Game?
    
    // Current User
    var user = User()
    
    // Firebase firestore database referance
    private var db = Firestore.firestore()
    
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
        
        // Find opponent.
        self.findOpponent()
        
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
//
//            // Increase time interval every seconds
//            self.timeInterval += 1
//
//            if self.timeInterval == 10 {
//                self.alertWithOkAndCancelAction(title: "Rakip Bulunamadı", message: "Şu anda düllo yapabileceğiniz bir kullanıcı bulunamadı. Tekrar denemek ister misiniz?", okButtonTitle: "Tekrar Dene", cancelButtonTitle: "Hayır", okButtonHandler: { (_) in
//
//                }, cancelButtonHandler: { (_) in
//
//                    // Go to main view.
//                    self.performSegue(withIdentifier: "mainViewSegue", sender: self)
//                })
//            }
//        }
        
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
        
        functions.httpsCallable("helloWorlds").call(["text" : "duel", "push" : true]) { (result, error) in
            
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
            
            if let text = result?.data as? [String : String] {
                print("Result: \(text)")
                
                self.db.collection("Game").getDocuments(completion: { (snapshot, error) in
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        if let documents = snapshot?.documents {
                            for document in documents {
                                if document.documentID == text["game"] {
                                    self.game = Game(
                                        win: document["win"] as? String,
                                        message: document["message"] as? [String : String],
                                        users: document["users"] as? [String : Bool],
                                        scores: document["scores"] as? [String : Int],
                                        moves: document["moves"] as? [String : Bool],
                                        playing: document["playing"] as? Bool,
                                        game: document["game"] as? String,
                                        random: document["random"] as? Int
                                    )
                                    
                                    self.performSegue(withIdentifier: "arenaSegue", sender: self)
                                    
                                }
                            }
                        }
                    }
                })
                
            } else {
                self.alertWithOkAndCancelAction(title: "Rakip Bulunamadı", message: "Şu anda düllo yapabileceğiniz bir kullanıcı bulunamadı. Tekrar denemek ister misiniz?", okButtonTitle: "Tekrar Dene", cancelButtonTitle: "Hayır", okButtonHandler: { (_) in

                    // Try find opponent again.
                    self.findOpponent()
                    
                }, cancelButtonHandler: { (_) in

                    // Go to main view.
                    self.performSegue(withIdentifier: "mainViewSegue", sender: self)
                })
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArenaViewController {
            vc.game = game
        }
    }

}

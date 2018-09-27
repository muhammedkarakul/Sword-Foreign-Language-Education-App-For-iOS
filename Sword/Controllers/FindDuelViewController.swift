//
//  FindDuelViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 12.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class FindDuelViewController: UIViewController {
    
    // MARK: - Properties
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup view.
        setupView()
        
        // Find a opponent and go to duel view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        
    }

}

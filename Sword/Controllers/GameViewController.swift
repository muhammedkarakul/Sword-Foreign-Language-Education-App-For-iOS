//
//  DuelViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class GameViewController: CustomMainViewController {
    
    // MARK: - Properties
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var findDuelButton: CustomButton!
    
    private var gameType: GameType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    /**
     * When touch button, go to find duel view.
     */
    
    @IBAction func findDuel(_ sender: CustomButton) {
        gameType = .duel
        performSegue(withIdentifier: "findOpponentSegue", sender: self)
    }
    
    @IBAction func findCardGame(_ sender: CustomButton) {
        gameType = .duel
        performSegue(withIdentifier: "findOpponentSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let findOpponentViewController = segue.destination as? FindOpponentViewController {
            findOpponentViewController.gameType = gameType
        }
    }
 

}

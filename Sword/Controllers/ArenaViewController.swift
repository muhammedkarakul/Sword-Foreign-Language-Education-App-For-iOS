//
//  ArenaViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 12.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ArenaViewController: CustomViewController {
    
    // MARK: - Properties
    @IBOutlet var timeCircularProgressRing: UICircularProgressRing!
    
    // User Data
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userScoreLabel: UILabel!
    
    // Opponent Data
    @IBOutlet var opponentImageView: UIImageView!
    @IBOutlet var opponentNameLabel: UILabel!
    @IBOutlet var opponentScoreLabel: UILabel!
    
    // Multiple Selection Objects
    @IBOutlet var multipleSelectionFirstButton: CustomButton!
    @IBOutlet var multipleSelectionSecondButton: CustomButton!
    @IBOutlet var multipleSelectionThirdButton: CustomButton!
    @IBOutlet var multipleSelectionFourthButton: CustomButton!
    
    // Multiple Selection Buttons Array
    private var multipleSelectionButtons = [CustomButton]()
    
    // Game object
    public var game: Game?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let game = game {
            print("GAME: \(game)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

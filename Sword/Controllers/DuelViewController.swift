//
//  DuelViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class DuelViewController: CustomMainViewController {
    
    // MARK: - Properties
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var findDuelButton: UIButtonWithRoundedCorners!
    
    
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
    
    @IBAction func findDuel(_ sender: UIButtonWithRoundedCorners) {
        performSegue(withIdentifier: "findDuelSegue", sender: self)
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

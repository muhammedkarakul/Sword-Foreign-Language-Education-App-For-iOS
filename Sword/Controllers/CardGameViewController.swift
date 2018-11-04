//
//  CardGameViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 26.10.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class CardGameViewController: CustomViewController {

    // MARK: - Properties
    
    // Game object.
    public var game: Game?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Print game object items.
        game?.printData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

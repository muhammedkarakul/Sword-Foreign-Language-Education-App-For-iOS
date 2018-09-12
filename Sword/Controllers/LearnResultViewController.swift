//
//  LearnResultViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 7.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class LearnResultViewController: UIViewController {
    
    @IBOutlet var trophyButton: UIButtonWithRoundedCornersAndBottomShadow!
    @IBOutlet var coinButton: UIButtonWithRoundedCornersAndBottomShadow!
    @IBOutlet var qualityButton: UIButtonWithRoundedCornersAndBottomShadow!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func completeLearning(_ sender: UIButtonWithRoundedCorners) {
        performSegue(withIdentifier: "unwindSegueToHead", sender: self)
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

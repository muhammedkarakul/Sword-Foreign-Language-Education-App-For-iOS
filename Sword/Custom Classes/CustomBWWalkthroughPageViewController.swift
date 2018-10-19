//
//  BWWalkthroughViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 15.10.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import BWWalkthrough

class CustomBWWalkthroughPageViewController: BWWalkthroughPageViewController {
    
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var subtitleLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        subtitleLabel?.sizeToFit()
    }
}

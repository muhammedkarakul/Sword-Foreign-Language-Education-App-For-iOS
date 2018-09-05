//
//  UIButtonWithRoundedCorners.swift
//  Sword
//
//  Created by Muhammed Karakul on 21.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class UIButtonWithRoundedCorners: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Rounderd Corners
        layer.borderWidth = 1.0
        layer.borderColor = tintColor.cgColor
        layer.cornerRadius = 25.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setBackgroundImage(UIImage(color: tintColor), for: .highlighted)
    }

}

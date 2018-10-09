//
//  UIButtonWithRounderdCornersAndBottomShadow.swift
//  Sword
//
//  Created by Muhammed Karakul on 2.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class MultipleSelectionButton: CustomButton {
    
    func changeAppearance(withAnswerState state: Bool) {
        if state {
            backgroundColor = UIColor.customColors.green
            borderColor = UIColor.customColors.borderGreen
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = UIColor.customColors.red
            borderColor = UIColor.customColors.borderRed
            setTitleColor(.white, for: .normal)
        }
    }
    
}

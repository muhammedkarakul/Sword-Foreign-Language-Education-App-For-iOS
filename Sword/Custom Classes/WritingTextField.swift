//
//  WritingTextField.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.10.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class WritingTextField: UITextField {

    func changeAppearance(withAnswerState state: Bool) {
        if state {
            textColor = UIColor.customColors.green
        } else {
            textColor = UIColor.customColors.red
        }
    }

}

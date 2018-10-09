//
//  GTProgressBar+update.swift
//  Sword
//
//  Created by Muhammed Karakul on 8.10.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import GTProgressBar

extension GTProgressBar {
    internal func update() {
        self.animateTo(progress: self.progress)
    }
}

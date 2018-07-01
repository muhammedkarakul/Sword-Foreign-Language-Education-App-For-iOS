//
//  CustomOverlayView.swift
//  Sword
//
//  Created by Muhammed Karakul on 18.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class CustomOverlayView: UIView {
    
    @IBOutlet var userProfilePhotoImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userExperienceProgressBar: UIProgressView!
    @IBOutlet var userExperienceLabel: UILabel!
    @IBOutlet var healthImageView: UIImageView!
    @IBOutlet var healthLabel: UILabel!
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var coinLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        userProfilePhotoImageView.layer.borderWidth = 2
        userProfilePhotoImageView.layer.masksToBounds = false
        userProfilePhotoImageView.layer.borderColor = UIColor.white.cgColor
        userProfilePhotoImageView.layer.cornerRadius = userProfilePhotoImageView.frame.height/2
        userProfilePhotoImageView.clipsToBounds = true
        
        
        // Kullanıcı bilgileri navigation bara yazdırılıyor.
        userNameLabel.text = "Bingo!"
    }
    
}

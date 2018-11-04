//
//  CustomOverlayView.swift
//  Sword
//
//  Created by Muhammed Karakul on 18.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class CustomOverlayView: UIView {
    
    private var user = User()
    private var userDefaults = UserDefaults.standard
    
    @IBOutlet var userProfilePhotoImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userExperienceProgressBar: UIProgressView!
    @IBOutlet var userExperienceLabel: UILabel!
    @IBOutlet var healthImageView: UIImageView!
    @IBOutlet var healthLabel: UILabel!
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var coinLabel: UILabel!
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }
    }
    
    override func draw(_ rect: CGRect) {
        userProfilePhotoImageView.layer.borderWidth = 2
        userProfilePhotoImageView.layer.masksToBounds = false
        userProfilePhotoImageView.layer.borderColor = UIColor.white.cgColor
        userProfilePhotoImageView.layer.cornerRadius = userProfilePhotoImageView.frame.height/2
        userProfilePhotoImageView.clipsToBounds = true
        userProfilePhotoImageView.image = UIImage(named: userDefaults.string(forKey: "ProfilePicture") ?? "defaultProfilePhoto-1")
        
        user = RealmUtilities.getCurrentUserFromRealm()
        
        // Kullanıcı bilgileri navigation bara yazdırılıyor.
        userNameLabel.text = user.getName()
        userExperienceLabel.text = "\(user.getScore() ?? 0)/1000"
        healthLabel.text = String(user.getHearth() ?? 0)
        coinLabel.text = String(user.getDiamond() ?? 0)
    }
    
    /**
     * Updates view with last user data.
     */
     internal func update() {
        
        userProfilePhotoImageView.image = UIImage(named: userDefaults.string(forKey: "ProfilePicture") ?? "defaultProfilePhoto-1")
        
        // Kullanıcı bilgileri navigation bara yazdırılıyor.
        userNameLabel.text = user.getName()
        userExperienceLabel.text = "\(user.getScore() ?? 0)/1000"
        healthLabel.text = String(user.getHearth() ?? 0)
        coinLabel.text = String(user.getDiamond() ?? 0)
    }
}

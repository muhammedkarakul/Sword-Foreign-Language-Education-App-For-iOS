//
//  CustomOverlayView.swift
//  Sword
//
//  Created by Muhammed Karakul on 18.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class CustomOverlayView: UIView {
    
    var user = User()
    
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
        
        
        user = getCurrentUserFromRealm()
        
        // Kullanıcı bilgileri navigation bara yazdırılıyor.
        userNameLabel.text = user.getName()
        userExperienceLabel.text = "\(user.getScore() ?? 0)/1000"
        healthLabel.text = String(user.getHearth() ?? 0)
        coinLabel.text = String(user.getDiamond() ?? 0)
    }
    
    private func getCurrentUserFromRealm() -> User {
        let realmUsers = uiRealm.objects(RealmUser.self)
        var users = [User]()
        let userDefaults = UserDefaults.standard
        var currentUser = User()
        
        for realmUser in realmUsers {
            var tempUser = User()
            tempUser = User(
                id: realmUser.id,
                name: realmUser.name,
                email: realmUser.email,
                diamond: realmUser.diamond.value,
                createdDate: realmUser.createdDate,
                hearth: realmUser.hearth.value,
                profilePhotoURL: realmUser.profilePhotoURL,
                score: realmUser.score.value,
                level: realmUser.level,
                topics: realmUser.topic?.components(separatedBy: ",")
            )
            
            users.append(tempUser)
        }
        
        for user in users {
            if user.getId() == userDefaults.string(forKey: "uid") {
                currentUser = user
            }
        }
        
        return currentUser
    }
    
}

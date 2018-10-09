//
//  Utilities.swift
//  Sword
//
//  Created by Muhammed Karakul on 23.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class Utilities {
    
    public static func getCurrentUserFromRealm() -> User {
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

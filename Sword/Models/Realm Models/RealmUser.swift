//
//  RealmUser.swift
//  Sword
//
//  Created by Muhammed Karakul on 1.11.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import RealmSwift

class RealmUser: Object {
    @objc dynamic var id: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var email: String? = nil
    var diamond = RealmOptional<Int>()
    @objc dynamic var createdDate: Date? = nil
    var hearth = RealmOptional<Int>()
    @objc dynamic var profilePhotoURL: String? = nil
    var score = RealmOptional<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: true)
        }
    }
    
    public func initWith(userObject user: User) {
        id = user.getId()
        name = user.getName()
        email = user.getEmail()
        diamond.value = user.getDiamond()
        createdDate = user.getCreatedDate()
        hearth.value = user.getHearth()
        profilePhotoURL = user.getProfilePhotoURL()
        score.value = user.getScore()
    }
    
    public func getUser() -> User {
        
        let user = User(id: id, name: name, email: email, diamond: diamond.value, createdDate: createdDate, hearth: hearth.value, profilePhotoURL: profilePhotoURL, score: score.value)//, level: level, topics: topic?.components(separatedBy: ","))
        
        return user
    }
    
}

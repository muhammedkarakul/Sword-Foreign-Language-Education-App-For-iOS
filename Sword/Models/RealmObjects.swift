//
//  RealmObjects.swift
//  Sword
//
//  Created by Muhammed Karakul on 14.06.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWord: Object {
    @objc dynamic var id: String? = nil
    @objc dynamic var foreignLang: String? = nil
    @objc dynamic var motherLang: String? = nil
    @objc dynamic var createdDate: Date? = nil
    @objc dynamic var users: String? = nil
    //var learnStatus = RealmOptional<Bool>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: true)
        }
    }
}

class RealmUser: Object {
    @objc dynamic var id: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var email: String? = nil
    var diamond = RealmOptional<Int>()
    @objc dynamic var createdDate: Date? = nil
    var hearth = RealmOptional<Int>()
    @objc dynamic var profilePhotoURL: String? = nil
    var score = RealmOptional<Int>()
    @objc dynamic var level: String? = nil
    @objc dynamic var topic: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: true)
        }
    }
    
    func getDataFromUser(user: User) {
       id = user.getId()
       name = user.getName()
       email = user.getEmail()
       diamond.value = user.getDiamond()
       createdDate = user.getCreatedDate()
       hearth.value = user.getHearth()
       profilePhotoURL = user.getProfilePhotoURL()
       score.value = user.getScore()
       level = user.getLevel()
       topic = String.arrayToString(stringArray: user.getTopics(), divideBy: ",")
    }
}

class RealmLevel: Object {
    @objc dynamic var id: String? = nil
    @objc dynamic var createdDate: Date? = nil
    @objc dynamic var name: String? = nil
    var score = RealmOptional<Int>()
    @objc dynamic var topics: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: true)
        }
    }
}

class RealmTopic: Object {
    @objc dynamic var id: String? = nil
    @objc dynamic var createdDate: Date? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var words: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: true)
        }
    }
}


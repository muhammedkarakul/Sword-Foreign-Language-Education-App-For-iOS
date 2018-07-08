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


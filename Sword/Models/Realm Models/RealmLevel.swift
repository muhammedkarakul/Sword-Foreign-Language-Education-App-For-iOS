//
//  RealmLevel.swift
//  Sword
//
//  Created by Muhammed Karakul on 1.11.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import RealmSwift

class RealmLevel: Object {
    @objc dynamic var id: String? = nil
    @objc dynamic var createdDate: Date? = nil
    @objc dynamic var name: String? = nil
    var score = RealmOptional<Int>()
    @objc dynamic var topics: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: true)
        }
    }
    
    public func getLevel() -> Level {
        let level = Level(
            id: id,
            createdDate: createdDate,
            name: name,
            score: score.value,
            topics: topics?.components(separatedBy: ",")
        )
        
        return level
    }
}

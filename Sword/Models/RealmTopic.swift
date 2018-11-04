//
//  RealmObjects.swift
//  Sword
//
//  Created by Muhammed Karakul on 14.06.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import RealmSwift

class RealmTopic: Object {
    @objc dynamic var id: String? = nil
    @objc dynamic var createdDate: Date? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var words: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: true)
        }
    }
    
    public func getTopic() -> Topic {
        let topic = Topic(
            id: id,
            createdDate: createdDate,
            name: name,
            words: words?.components(separatedBy: ",")
        )
        
        return topic
    }
}


//
//  RealmWord.swift
//  Sword
//
//  Created by Muhammed Karakul on 1.11.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import RealmSwift

class RealmWord: Object {
    @objc dynamic var id: String? = nil
    @objc dynamic var foreignLang: String? = nil
    @objc dynamic var motherLang: String? = nil
    @objc dynamic var createdDate: Date? = nil
    @objc dynamic var users: String? = nil
    @objc dynamic var imageURL: String? = nil
    var random = RealmOptional<Int>()
    var rating = RealmOptional<Int>()
    @objc dynamic var sentence: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: true)
        }
    }
    
    public func getWord() -> Word {
        let word = Word(
            id: id,
            foreignLang: foreignLang,
            motherLang: motherLang,
            createdDate: createdDate,
            users: users?.components(separatedBy: ","),
            imageURL: imageURL,
            random: random.value,
            rating: rating.value,
            sentence: sentence
        )
        
        return word
    }
}

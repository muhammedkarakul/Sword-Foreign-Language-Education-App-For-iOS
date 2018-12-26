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
    var users = List<RealmWordUser>()
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
            users: getUserDataAsDictionary(),
            imageURL: imageURL,
            random: random.value,
            rating: rating.value,
            sentence: sentence
        )
        
        return word
    }
    
    public func getData(fromWord word: Word) {
        id = word.getId()
        foreignLang = word.getForeignLang()
        motherLang = word.getMotherLang()
        createdDate = word.getCreatedDate()
        users = getUserDataAsRealmWordUser(fromDictionary: word.getUsers())
        imageURL = word.getImageURL()
        random.value = word.getRandom()
        rating.value = word.getRating()
        sentence = word.getSentence()
    }
    
    private func getUserDataAsDictionary() -> [String : Bool]? {
        
        var usersDictionary = [String : Bool]()
        
        for user in  users {
            usersDictionary[user.key!] = user.getBoolValue()
        }
        
        return usersDictionary
    }
    
    private func getUserDataAsRealmWordUser(fromDictionary dictionary: [String : Bool]?) -> List<RealmWordUser> {
        let realmWordUsers = List<RealmWordUser>()
        if let users = dictionary {
            for (key, value) in users {
                let realmWordUser = RealmWordUser()
                realmWordUser.key = key
                realmWordUser.setValue(fromBool: value)
                
                realmWordUsers.append(realmWordUser)
            }
        }
    
        return realmWordUsers
    }
}

class RealmWordUser : Object {
    @objc dynamic var key: String? = nil
    @objc dynamic var value: String? = nil
    
    public func getBoolValue() -> Bool {
        if value == "true" {
            return true
        } else {
            return false
        }
    }
    
    public func setValue(fromBool bool: Bool?) {
        if bool == true {
            value = "true"
        } else {
            value = "false"
        }
    }
}

//
//  Utilities.swift
//  Sword
//
//  Created by Muhammed Karakul on 23.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class RealmUtilities {
    
    public static func getCurrentUserFromRealm() -> User {
        
        let userDefaults = UserDefaults.standard
        let currentUser = getUserFromRealm(withId: userDefaults.string(forKey: "uid"))
        
        return currentUser
    }
    
    public static func getUserFromRealm(withId id: String? ) -> User {
        let realmUsers = uiRealm.objects(RealmUser.self)
        var user = User()
        
        for realmUser in realmUsers {
            if realmUser.id == id {
                user = realmUser.getUser()
            }
        }
        
        return user
    }
    
    
    
    public static func getLevelsFromRealm() -> [Level] {
        let realmLevels = uiRealm.objects(RealmLevel.self)
        var levels = [Level]()
        
        for realmLevel in realmLevels {
            
            levels.append(realmLevel.getLevel())
            
        }
        
        return levels
    }
    
    public static func getTopicsFromRealm() -> [Topic] {
        let realmTopics = uiRealm.objects(RealmTopic.self)
        var topics = [Topic]()
        
        for realmTopic in realmTopics {
            
            topics.append(realmTopic.getTopic())
            
        }
        
        return topics
    }
    
    public static func getWordsFromRealm() -> [Word] {
        let realmWords = uiRealm.objects(RealmWord.self)
        var words = [Word]()
        
        for realmWord in realmWords {
            words.append(realmWord.getWord())
        }
        
        return words
    }
    
    public static func getWordsFromRealm(withRandom random: Int?) -> [Word] {
        let words = getWordsFromRealm()
        var wordsWithRandom = [Word]()
        for word in words {
            if word.getRandom() == random {
                wordsWithRandom.append(word)
            }
        }
        
        return wordsWithRandom
    }
    
}

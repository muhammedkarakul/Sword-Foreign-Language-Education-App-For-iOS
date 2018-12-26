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
        
        var currentUser = User()
        
        if let currentUserId = UserDefaultsUtilities.getCurrentUserId() {
            currentUser = getUserFromRealm(withId: currentUserId)
        }
        
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
    
    public static func getLevel(withId id: String?) -> Level {
        let levels = getLevelsFromRealm()
        var tempLevel = Level()
        for level in levels {
            if level.getId() == id {
                tempLevel = level
            }
        }
        return tempLevel
    }
    
    
    public static func getTopicsFromRealm() -> [Topic] {
        let realmTopics = uiRealm.objects(RealmTopic.self)
        var topics = [Topic]()
        
        for realmTopic in realmTopics {
            
            topics.append(realmTopic.getTopic())
            
        }
        
        return topics
    }
    
    public static func getTopic(withId id: String?) -> Topic {
        let topics = getTopicsFromRealm()
        var tempTopic = Topic()
        for topic in topics {
            if topic.getId() == id {
                tempTopic = topic
            }
        }
        
        return tempTopic
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
    
    public static func updateUser(profilePhotoURL url: String?) {
        let currentUser = getCurrentUserFromRealm()
        if let profilePhotoURL = url {
            currentUser.setProfilePhotoURL(profilePhotoURL: profilePhotoURL)
        }
        let realmUser = RealmUser()
        realmUser.initWith(userObject: currentUser)
        realmUser.writeToRealm()
    }
    
}

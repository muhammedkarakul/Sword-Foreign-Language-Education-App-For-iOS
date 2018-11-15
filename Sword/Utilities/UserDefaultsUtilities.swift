//
//  UserDefaultsUtilities.swift
//  Sword
//
//  Created by Muhammed Karakul on 15.11.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class UserDefaultsUtilities {
    
    static public func isWalkthroughPresented() -> Bool? {
        return UserDefaults.standard.bool(forKey: "walkthroughPresented")
    }
    
    static public func getCurrentUserId() -> String? {
        return UserDefaults.standard.string(forKey: "currentUserId")
    }
    
    static public func getSelectedTopics() -> [String]? {
        return UserDefaults.standard.array(forKey: "selectedTopics") as? [String]
    }
    
    static public func getSelectedLevel() -> String? {
        return UserDefaults.standard.string(forKey: "selectedLevel")
    }
}

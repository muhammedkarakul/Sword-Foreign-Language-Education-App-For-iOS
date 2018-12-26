//
//  String+DictionaryToString.swift
//  Sword
//
//  Created by Muhammed Karakul on 16.11.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

extension String {
    public static func dictionaryToString(stringDictionary: [String : Any]?, divideBy: String?) -> String? {
        var tempString = ""
        if let stringDict = stringDictionary {
            var dictionaryCounter = 0
            for string in stringDict {
                dictionaryCounter += 1
                tempString += "\(string.key):\(string.value)"
                if dictionaryCounter < stringDict.count {
                    tempString += divideBy ?? ""
                }
            }
        }
        return tempString
    }
}

//
//  String+ArrayToString.swift
//  Sword
//
//  Created by Muhammed Karakul on 23.07.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

extension String {
    public static func arrayToString(stringArray: [String]?, divideBy: String?) -> String? {
        var tempString = ""
        if let stringArr = stringArray {
            var arrayCounter = 0
            for string in stringArr {
                arrayCounter += 1
                tempString += string
                if arrayCounter < stringArr.count {
                    tempString += divideBy ?? ""
                }
            }
        }
        return tempString
    }
}

//
//  Date+TimeStampToDate.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.06.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension Date {
    static public func timeStampToDate(withAnyObject any: Any?) -> Date? {
        
        var date = Date()
        
        let timestamp = any as? Timestamp
        
        if let timestamp = timestamp {
            date = timestamp.dateValue()
        }
        
        return date
    }
}

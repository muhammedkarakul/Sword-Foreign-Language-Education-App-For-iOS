//
//  Date+TimeStampToDate.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.06.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

extension Date {
    static public func timeStampToDate(timeStamp: Double) -> Date? {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        return date
    }
}

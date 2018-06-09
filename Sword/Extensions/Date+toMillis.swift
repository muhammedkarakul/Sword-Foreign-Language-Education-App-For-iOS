//
//  Date+toMillis.swift
//  Sword
//
//  Created by Muhammed Karakul on 5.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

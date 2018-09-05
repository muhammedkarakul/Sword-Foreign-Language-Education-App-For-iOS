//
//  Sequence+Shuffled.swift
//  Sword
//
//  Created by Muhammed Karakul on 1.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

//
//  Array+Shuffled.swift
//  SwordLearnAlgorithm
//
//  Created by Muhammed Karakul on 23.08.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

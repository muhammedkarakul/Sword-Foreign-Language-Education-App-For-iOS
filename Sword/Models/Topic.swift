//
//  Topic.swift
//  Sword
//
//  Created by Muhammed Karakul on 8.07.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class Topic {
    
    // MARK: - Properties
    
    private var id: String?
    private var createdDate: Date?
    private var name: String?
    private var words: [String]?
    
    // MARK: - Initializers
    
    init() {
        id = ""
        createdDate = Date()
        name = ""
        words = [String]()
    }
    
    init(id: String?, createdDate: Date?, name: String?, words: [String]?) {
        self.id = id
        self.createdDate = createdDate
        self.name = name
        self.words = words
    }
    
    // MARK: - Setter Methods
    public func setId(id: String?) { self.id = id }
    public func setCreatedDate(createdDate: Date?) { self.createdDate = createdDate }
    public func setName(name: String?) { self.name = name }
    public func setWords(words: [String]?) { self.words = words }
    
    // MARK: - Getter Methods
    public func getId() -> String? { return id }
    public func getCreatedDate() -> Date? { return createdDate }
    public func getName() -> String? { return name }
    public func getWords() -> [String]? { return words }
}

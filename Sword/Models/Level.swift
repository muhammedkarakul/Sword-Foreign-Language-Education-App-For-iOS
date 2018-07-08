//
//  Level.swift
//  Sword
//
//  Created by Muhammed Karakul on 8.07.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class Level {
    
    // MARK: - Properties
    private var id: String?
    private var createdDate: Date?
    private var name: String?
    private var score: Int?
    private var topics: [String?]
    
    // MARK: - Initializers
    
    /**
     *  Initialize with no parameter.
     */
    init() {
        id = ""
        createdDate = Date()
        name = ""
        score = 0
        topics = [String]()
    }
    
    /**
     *  Intialize with parameters.
     *  - parameter id: Level id.
     *  - parameter createdDate: Level created date.
     *  - parameter name: Level name.
     *  - parameter score: Level score.
     *  - parameter topics: Level topics.
     */
    init(id: String?, createdDate: Date?, name: String?, score: Int?, topics: [String?]) {
        self.id = id
        self.createdDate = createdDate
        self.name = name
        self.score = score
        self.topics = topics
    }
    
    // MARK: - Setter Methods
    
    public func setId(id: String?) { self.id = id }
    public func setCreatedDate(createdDate: Date?) { self.createdDate = createdDate }
    public func setName(name: String?) { self.name = name }
    public func setScore(score: Int?) { self.score = score }
    public func setTopics(topics: [String?]) { self.topics = topics }
    
    
    // MARK: - Getter Methods
    
    public func getId() -> String? { return id }
    public func getCreatedDate() -> Date? { return createdDate }
    public func getName() -> String? { return name }
    public func getScore() -> Int? { return score }
    public func getTopics() -> [String?] { return topics }
}

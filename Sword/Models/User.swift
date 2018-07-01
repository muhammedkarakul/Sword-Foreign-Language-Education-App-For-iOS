//
//  User.swift
//  Sword
//
//  Created by Muhammed Karakul on 5.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class User {
    // MARK: - Properties -
    private var id: String?
    private var name: String?
    private var email: String?
    private var diamond: Int?
    private var createdDate: Date?
    private var hearth: Int?
    private var profilePhotoURL: String?
    private var score: Int?
    private var level: String?
    private var topic: String?
    
    // MARK: - Constructor Methods -
    
    init() {
        id = ""
        name = ""
        email = ""
        diamond = 0
        createdDate = Date()
        hearth = 0
        profilePhotoURL = ""
        score = 0
        level = ""
        topic = ""
    }
    
    init(id: String, name: String, email: String, diamond: Int, createdDate: Date, hearth: Int, profilePhotoURL: String, score: Int, level: String, topic: String) {
        self.id = id
        self.name = name
        self.email = email
        self.diamond = diamond
        self.createdDate = createdDate
        self.hearth = hearth
        self.profilePhotoURL = profilePhotoURL
        self.score = score
        self.level = level
        self.score = score
    }
    
    // MARK: - Getter Methods -
    
    func getId() -> String? { return id }
    func getName() -> String? { return name }
    func getEmail() -> String? { return email }
    func getDiamond() -> Int? { return diamond }
    func getCreatedDate() -> Date? { return createdDate }
    func getHearth() -> Int? { return hearth }
    func getScore() -> Int? { return score }
    func getProfilePhotoURL() -> String? { return profilePhotoURL }
    func getLevel() -> String? { return level }
    func getTopic() -> String? { return topic }
    
    // MARK: - Setter Methods -
    
    func setId(id: String) { self.id = id }
    func setName(name: String) { self.name = name }
    func setEmail(email: String) { self.email = email }
    func setDiamond(diamond: Int) { self.diamond = diamond }
    func setCreatedDate(createdDate: Date) { self.createdDate = createdDate }
    func setHearth(hearth: Int) { self.hearth = hearth }
    func setProfilePhotoURL(profilePhotoURL: String) { self.profilePhotoURL = profilePhotoURL }
    func setScore(score: Int) { self.score = score}
    func setLevel(level: String) { self.level = level }
    func setTopic(topic: String) { self.topic = topic }
    
    // MARK: - Utilities Methods -
    
    func printUserData() {
        print("*** USER DATA ***")
        print("id: \(getId()!)")
        print("name: \(getName()!)")
        print("email: \(getEmail()!)")
        print("diamond: \(getDiamond()!)")
        print("created date: \(getCreatedDate()!)")
        print("hearth: \(getHearth()!)")
        print("profile photo url: \(getProfilePhotoURL()!)")
        print("score: \(getScore()!)")
        print("level: \(getLevel()!)")
        print("topic: \(getTopic()!)")
        print("*****************")
    }
    
}

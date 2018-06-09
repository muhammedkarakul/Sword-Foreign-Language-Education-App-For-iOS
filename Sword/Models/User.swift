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
    private var name: String?
    private var email: String?
    private var diamond: Int?
    private var createdDay: Date?
    private var hearth: Int?
    private var profilePhotoURL: String?
    private var score: Int?
    
    // MARK: - Constructor Methods -
    
    init() {
        name = ""
        email = ""
        diamond = 0
        createdDay = Date()
        hearth = 0
        profilePhotoURL = ""
        score = 0
    }
    
    init(name: String, email: String, diamond: Int, createdDay: Date, hearth: Int, profilePhotoURL: String, score: Int) {
        self.name = name
        self.email = email
        self.diamond = diamond
        self.createdDay = createdDay
        self.hearth = hearth
        self.profilePhotoURL = profilePhotoURL
        self.score = score
    }
    
    // MARK: - Getter Methods -
    
    func getName() -> String? { return name }
    func getEmail() -> String? { return email }
    func getDiamond() -> Int? { return diamond }
    func getCreatedDay() -> Date? { return createdDay }
    func getHearth() -> Int? { return hearth }
    func getScore() -> Int? { return score }
    func getProfilePhotoURL() -> String? { return profilePhotoURL }
    
    
    
    // MARK: - Setter Methods -
    
    func setName(name: String) { self.name = name }
    func setEmail(email: String) { self.email = email }
    func setDiamond(diamond: Int) { self.diamond = diamond }
    func setCreatedDay(createdDay: Date) { self.createdDay = createdDay }
    func setHearth(hearth: Int) { self.hearth = hearth }
    func setProfilePhotoURL(profilePhotoURL: String) { self.profilePhotoURL = profilePhotoURL }
    func setScore(score: Int) { self.score = score}
    
}

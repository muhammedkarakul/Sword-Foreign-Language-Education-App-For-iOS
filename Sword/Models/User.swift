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
//    private var level: String?
//    private var topics: [String]?
    
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
//        level = ""
//        topics = [String]()
    }
    
    init(id: String?, name: String?, email: String?, diamond: Int?, createdDate: Date?, hearth: Int?, profilePhotoURL: String?, score: Int?) {
        self.id = id
        self.name = name
        self.email = email
        self.diamond = diamond
        self.createdDate = createdDate
        self.hearth = hearth
        self.profilePhotoURL = profilePhotoURL
        self.score = score
        self.score = score
        //self.level = level
        //self.topics = topics
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
    //func getLevel() -> String? { return level }
    //func getTopics() -> [String]? { return topics }
    
    func getUserData(fromDictionary dictionary: [String : Any]?) {
        
    }
    
    // MARK: - Setter Methods -
    
    func setId(id: String?) { self.id = id }
    func setName(name: String?) { self.name = name }
    func setEmail(email: String?) { self.email = email }
    func setDiamond(diamond: Int?) { self.diamond = diamond }
    func setCreatedDate(createdDate: Date?) { self.createdDate = createdDate }
    func setHearth(hearth: Int?) { self.hearth = hearth }
    func setProfilePhotoURL(profilePhotoURL: String) { self.profilePhotoURL = profilePhotoURL }
    func setScore(score: Int?) { self.score = score}
    //func setLevel(level: String?) { self.level = level }
    //func setTopic(topics: [String]?) { self.topics = topics }
    
    // MARK: - Utilities Methods -
    
    public func printUserData() {
        print("*** USER DATA ***")
        print("id: \(getId() ?? "")")
        print("name: \(getName() ?? "")")
        print("email: \(getEmail() ?? "")")
        print("diamond: \(getDiamond() ?? 0)")
        print("created date: \(getCreatedDate() ?? Date())")
        print("hearth: \(getHearth() ?? 0)")
        print("profile photo url: \(getProfilePhotoURL() ?? "")")
        print("score: \(getScore() ?? 0)")
        //print("level: \(getLevel() ?? "")")
        //print("topic: \(getTopics() ?? [String]())")
        print("*****************")
    }
    
    public func getData() -> [String : Any]? {
        
        let userData: [String : Any]? = [
            "id": getId() ?? "",
            "name": getName() ?? "",
            "email": getEmail() ?? "",
            "diamond": getDiamond() ?? 0,
            "createddate":getCreatedDate() ?? Date(),
            "hearth":getHearth() ?? 0,
            "profile photo url":getProfilePhotoURL() ?? "",
            "score": getScore() ?? 0
        ]
        
        return userData
    }
    
}

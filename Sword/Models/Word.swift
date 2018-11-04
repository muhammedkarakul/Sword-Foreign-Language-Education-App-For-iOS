//
//  Word.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.06.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class Word {
    // MARK: - Properties
    private var id: String?
    private var foreignLang: String?
    private var motherLang: String?
    private var createdDate: Date?
    private var users: [String]?
    private var learnStatus: Bool?
    private var imageURL: String?
    private var random: Int?
    private var rating: Int?
    private var sentence: String?
    
    // MARK: - Init Methods
    
    init() {
        id = ""
        foreignLang = ""
        motherLang = ""
        createdDate = Date()
        users = [String]()
        learnStatus = false
        imageURL = ""
        random = 0
        rating = 0
        sentence = ""
    }
    
    init(id: String?, foreignLang: String?, motherLang: String?, createdDate: Date?, users: [String]?, imageURL: String?, random: Int?, rating: Int?, sentence: String?) {
        self.id = id
        self.foreignLang = foreignLang
        self.motherLang = motherLang
        self.createdDate = createdDate
        self.users = users
        self.imageURL = imageURL
        self.random = random
        self.rating = rating
        self.sentence = sentence
        learnStatus = false
    }
    
    // MARK: - Setter Methods
    public func setId(id: String?) { self.id = id }
    public func setForeignLang(foreignLang: String?) { self.foreignLang = foreignLang }
    public func setMotherLang(motherLang: String?) { self.motherLang = motherLang }
    public func setCreatedDate(createdDate: Date?) { self.createdDate = createdDate }
    public func setUsers(users: [String]?) { self.users = users }
    public func setLearnStatus(learnStatus: Bool?) { self.learnStatus = learnStatus}
    public func setImageURL(imageURL: String?) { self.imageURL = imageURL }
    public func setRandom(random: Int?) { self.random = random }
    public func setRating(rating: Int?) { self.rating = rating }
    public func setSentence(sentence: String?) { self.sentence = sentence }
    
    // MARK: - Getter Methods
    public func getId() -> String? {return self.id}
    public func getForeignLang() -> String? { return self.foreignLang }
    public func getMotherLang() -> String? { return self.motherLang }
    public func getCreatedDate() -> Date? { return self.createdDate }
    public func getUsers() -> [String]? { return self.users }
    public func getLearnStatus() -> Bool? { return self.learnStatus }
    public func getImageURL() -> String? { return self.imageURL }
    public func getRandom() -> Int? { return self.random }
    public func getRating() -> Int? { return self.rating }
    public func getSentence() -> String? { return self.sentence }
    
}

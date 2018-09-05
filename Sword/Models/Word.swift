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
    
    // MARK: - Init Methods
    
    init() {
        id = ""
        foreignLang = ""
        motherLang = ""
        createdDate = Date()
        users = [String]()
        learnStatus = false
    }
    
    init(id: String?, foreignLang: String?, motherLang: String?, createdDate: Date?, users: [String]?) {
        self.id = id
        self.foreignLang = foreignLang
        self.motherLang = motherLang
        self.createdDate = createdDate
        self.users = users
        learnStatus = false
    }
    
    // MARK: - Setter Methods
    public func setId(id: String?) { self.id = id }
    public func setForeignLang(foreignLang: String?) { self.foreignLang = foreignLang }
    public func setMotherLang(motherLang: String?) { self.motherLang = motherLang }
    public func setCreatedDate(createdDate: Date?) { self.createdDate = createdDate }
    public func setUsers(users: [String]?) { self.users = users }
    public func setLearnStatus(learnStatus: Bool?) { self.learnStatus = learnStatus}
    
    // MARK: - Getter Methods
    public func getId() -> String? {return self.id}
    public func getForeignLang() -> String? { return self.foreignLang }
    public func getMotherLang() -> String? { return self.motherLang }
    public func getCreatedDate() -> Date? { return self.createdDate }
    public func getUsers() -> [String]? { return self.users }
    public func getLearnStatus() -> Bool? {return self.learnStatus}
    
}

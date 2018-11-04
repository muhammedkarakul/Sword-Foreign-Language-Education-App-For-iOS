//
//  DuelGame.swift
//  Sword
//
//  Created by Muhammed Karakul on 20.10.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class Game {
    
    // MARK: - Properties
    
    private var win: String?
    private var messages: [String : String]?
    private var users: [String : Bool]?
    private var scores: [String : Int]?
    private var moves: [String : Bool]?
    private var playing: Bool?
    private var game: String?
    private var random: Int?
    private var type: String?
    
    // MARK: - Initialization
    
    /**
     Game object initialization with no parameter.
     */
    init() {
        win = ""
        messages = [String : String]()
        users = [String : Bool]()
        scores = [String : Int]()
        moves = [String : Bool]()
        playing = true
        game = ""
        random = 0
        type = ""
    }
    
    /**
     Game object initialization with parameters.
     */
    init(
        win: String?,
        messages: [String : String]?,
        users: [String : Bool]?,
        scores: [String : Int]?,
        moves: [String : Bool]?,
        playing: Bool?,
        game: String?,
        random: Int?,
        type: String?
        ) {
        self.win = win
        self.messages = messages
        self.users = users
        self.scores = scores
        self.moves = moves
        self.playing = playing
        self.game = game
        self.random = random
        self.type = type
    }
    
    // MARK: - Getter Methods
    
    public func getWin() -> String? { return win }
    public func getMessages() -> [String : String]? { return messages }
    public func getUsers() -> [String : Bool]? { return users }
    public func getScores() -> [String : Int]? { return scores }
    public func getMoves() -> [String : Bool]? { return moves }
    public func getPlaying() -> Bool? { return playing }
    public func getGame() -> String? { return game }
    public func getRandom() -> Int? { return random }
    public func getType() -> String? { return type }
    
    // MARK: - Setter Methods
    
    public func setWin(win: String?) { self.win = win }
    public func setMessage(messages: [String : String]?) { self.messages = messages }
    public func setUsers(users: [String : Bool]?) { self.users = users }
    public func setScores(scores: [String : Int]?) { self.scores = scores }
    public func setMoves(moves: [String : Bool]?) { self.moves = moves }
    public func setPlaying(playing: Bool?) { self.playing = playing }
    public func setGame(game: String?) { self.game = game }
    public func setRandom(random: Int?) { self.random = random }
    public func setType(type: String?) { self.type = type }
    
    // MARK: - Utilities
    
    public func printData() {
        print("*** GAME DATA ***")
        
        if let win = self.win{
            print("Win: \(win)")
        }
        
        if let messages = self.messages {
            print("Message: \(messages)")
        }
        
        if let users = self.users {
            print("Users: \(users)")
        }
        
        if let scores = self.scores {
            print("Scores: \(scores)")
        }
        
        if let moves = self.moves {
            print("Moves: \(moves)")
        }
        
        if let playing = self.playing {
            print("Playing: \(playing)")
        }
        
        if let game = self.game {
            print("Game: \(game)")
        }
        
        if let random = self.random {
            print("Random: \(random)")
        }
        
        if let type = self.type {
            print("Type: \(type)")
        }
        
    }
}

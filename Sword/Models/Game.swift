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
    private var message: [String : String]?
    private var users: [String : Bool]?
    private var scores: [String : Int]?
    private var moves: [String : Bool]?
    private var playing: Bool?
    private var game: String?
    private var random: Int?
    
    // MARK: - Initialization
    
    /**
     Game object initialization with no parameter.
     */
    init() {
        win = ""
        message = [String : String]()
        users = [String : Bool]()
        scores = [String : Int]()
        moves = [String : Bool]()
        playing = true
        game = ""
        random = 0
    }
    
    /**
     Game object initialization with parameters.
     */
    init(
        win: String?,
        message: [String : String]?,
        users: [String : Bool]?,
        scores: [String : Int]?,
        moves: [String : Bool]?,
        playing: Bool?,
        game: String?,
        random: Int?
        ) {
        self.win = win
        self.message = message
        self.users = users
        self.scores = scores
        self.moves = moves
        self.playing = playing
        self.game = game
        self.random = random
    }
    
    // MARK: - Getter Methods
    
    public func getWin() -> String? { return win }
    public func getMessage() -> [String : String]? { return message }
    public func getUsers() -> [String : Bool]? { return users }
    public func getScores() -> [String : Int]? { return scores }
    public func getMoves() -> [String : Bool]? { return moves }
    public func getPlaying() -> Bool? { return playing }
    public func getGame() -> String? { return game }
    public func getRandom() -> Int? { return random }
    
    // MARK: - Setter Methods
    
    public func setWin(win: String?) { self.win = win }
    public func setMessage(message: [String : String]?) { self.message = message }
    public func setUsers(users: [String : Bool]?) { self.users = users }
    public func setScores(scores: [String : Int]?) { self.scores = scores }
    public func setMoves(moves: [String : Bool]?) { self.moves = moves }
    public func setPlaying(playing: Bool?) { self.playing = playing }
    public func setGame(game: String?) { self.game = game }
    public func setRandom(random: Int?) { self.random = random }
}

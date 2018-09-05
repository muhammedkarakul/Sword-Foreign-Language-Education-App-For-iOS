//
//  Question.swift
//  SwordLearnAlgorithm
//
//  Created by Muhammed Karakul on 22.08.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

enum QuestionType {
    case reading
    case listening
}

enum LanguageType {
    case foreign
    case mother
}

enum AnswerType {
    case multipleSelection
    case writing
}

class Question {
    private var type: QuestionType
    private var language: LanguageType
    private var answerType: AnswerType
    private var isAnswered: Bool
    private var word: Word
    private var wrongAnswerCounter: Int
    
    init() {
        type = QuestionType.reading
        language = LanguageType.foreign
        answerType = AnswerType.multipleSelection
        isAnswered = false
        word = Word()
        wrongAnswerCounter = 0
    }
    
    init(type: QuestionType, language: LanguageType, answerType: AnswerType, word: Word) {
        self.type = type
        self.language = language
        self.answerType = answerType
        self.isAnswered = false
        self.word = word
        wrongAnswerCounter = 0
    }
    
    public func getType() -> QuestionType {
        return type
    }
    
    public func getLanguage() -> LanguageType {
        return language
    }
    
    public func getWord() -> Word {
        return word
    }
    
    public func getText() -> String {
        switch language {
        case .foreign: return word.getForeignLang() ?? ""
        case .mother: return word.getMotherLang() ?? ""
        }
    }
    
    public func getRightAnswer() -> String {
        switch type {
        case .listening:
            switch language {
            case .mother: return word.getMotherLang() ?? ""
            case .foreign: return word.getForeignLang() ?? ""
            }
        case .reading:
            switch language {
            case .mother: return word.getForeignLang() ?? ""
            case .foreign: return word.getMotherLang() ?? ""
            }
        }
    }
    
    public func getAnswerState() -> Bool {
        return isAnswered
    }
    
    public func setAnswerState( state: Bool) {
        isAnswered = state
    }
    
    public func increaseWrongAnswerCounter() {
        wrongAnswerCounter = wrongAnswerCounter + 1
        
        print("wrongAnswerCounter: \(wrongAnswerCounter)")
    }
    
    public func checkWrongAnswerCounter() {
        if wrongAnswerCounter == 3 {
            isAnswered = true
        }
        print("isAnswered: \(isAnswered)")
    }
}

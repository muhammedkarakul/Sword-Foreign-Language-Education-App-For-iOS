//
//  Order.swift
//  Sword
//
//  Created by Muhammed Karakul on 7.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class QuestionOrder {
    
    // MARK: - Properties
    
    private var languageType: LanguageType
    private var answerType: AnswerType
    private var questionType: QuestionType
    
    // MARK: - Initialization Methods
    
    init() {
        languageType = .foreign
        answerType = .multipleSelection
        questionType = .reading
    }
    
    init(languageType: LanguageType, answerType: AnswerType, questionType: QuestionType) {
        self.languageType = languageType
        self.answerType = answerType
        self.questionType = questionType
    }
    
    // MARK: - Getter Methods
    
    public func getLanguageType() -> LanguageType {
        return languageType
    }
    
    public func getAnswerType() -> AnswerType {
        return answerType
    }
    
    public func getQuestionType() -> QuestionType {
        return questionType
    }
    
    // MARK: - Setter Methods
    
    public func setLanguageType(languageType: LanguageType) {
        self.languageType = languageType
    }
    
    public func setAnswerType(answerType: AnswerType) {
        self.answerType = answerType
    }
    
    public func setQuestionType(questionType: QuestionType) {
        self.questionType = questionType
    }
    
    // MARK: - Utilities
    public func setupQuestionOrder(withDictionary dictionary: [String : String]) {
        
        switch dictionary["QuestionType"] {
        case "Reading": questionType = .reading
        case "Listening": questionType = .listening
        default: break
        }
        
        switch dictionary["LanguageType"] {
        case "Foreign": languageType = .foreign
        case "Mother": languageType = .mother
        default: break
        }
        
        switch dictionary["AnswerType"] {
        case "MultipleSelection": answerType = .multipleSelection
        case "Writing": answerType = .writing
        default: break
        }
    }
}

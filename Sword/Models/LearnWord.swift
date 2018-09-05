//
//  LearnWord.swift
//  SwordLearnAlgorithm
//
//  Created by Muhammed Karakul on 22.08.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class LearnWord {
    private var multipleSelections: [MultipleSelection]
    private var writings: [Writing]
    
    init() {
        multipleSelections = [MultipleSelection]()
        writings = [Writing]()
    }
    
    init(multipleSelections: [MultipleSelection], writings: [Writing]) {
        self.multipleSelections = multipleSelections
        self.writings = writings
    }
    
    public func setupQuestions(withWords words: [Word]) -> [Question] {
        // Multiple selections
        
        var questions = [Question]()
        
        // Readings
        // Foreign Lang Multiple Selection Reading Question
        questions.insert(Question(type: .reading, language: .foreign, answerType: .multipleSelection, word: words[0]), at: 0)
        
        // Mother Lang Multiple Selection Reading Question
        questions.insert(Question(type: .reading, language: .mother, answerType: .multipleSelection, word: words[0]), at: 1)
        
        // Listenings
        //Foreign Lang Multiple Selection Listening Question
        questions.insert(Question(type: .listening, language: .foreign, answerType: .multipleSelection, word: words[0]), at: 2)
        
        // Mother Lang Multiple Selection Listening Question
        questions.insert(Question(type: .listening, language: .mother, answerType: .multipleSelection, word: words[0]), at: 3)
        // Writings
        
        // Readings
        // Foreign Lang Writing Reading Question
        questions.insert(Question(type: .reading, language: .foreign, answerType: .writing, word: words[0]), at: 4)
        
        // Mother Lang Writing Reading Question
        questions.insert(Question(type: .reading, language: .mother, answerType: .writing, word: words[0]), at: 5)
        
        // Listenings
        // Foreign Lang Listening Writing Question
        questions.insert(Question(type: .listening, language: .foreign, answerType: .writing, word: words[0]), at: 6)
        
        // Mother Lang Listening Writing Question
        questions.insert(Question(type: .listening, language: .mother, answerType: .writing, word: words[0]), at: 7)
        
        return questions
    }
    
    public func setupMultipleSelections(withQuestions questions: [Question], andWords words: [Word]) -> [MultipleSelection] {
        var multipleSelections = [MultipleSelection]()
        
        // Foreign Lang Reading Multiple Selection
        multipleSelections.insert(MultipleSelection(question: questions[0]), at: 0)
        multipleSelections[0].createAnswers(words: words)
        
        // Mother Lang Reading Multiple Selection
        multipleSelections.insert(MultipleSelection(question: questions[1]), at: 1)
        multipleSelections[1].createAnswers(words: words)
        
        // Foreign Lang Listening Multiple Selection
        multipleSelections.insert(MultipleSelection(question: questions[2]), at: 2)
        multipleSelections[2].createAnswers(words: words)
        
        // Mother Lang Listening Multiple Selection
        multipleSelections.insert(MultipleSelection(question: questions[3]), at: 3)
        multipleSelections[3].createAnswers(words: words)
        
        return multipleSelections
    }
    
    public func setupWritings(withQuestions questions: [Question]) -> [Writing] {
        var writings = [Writing]()
        
        // Foreign Lang Reading Writing
        writings.insert(Writing(question: questions[4]), at: 0)
        
        // Mother Lang Reading Writing
        writings.insert(Writing(question: questions[5]), at: 1)
        
        // Foreign Lang Listening Writing
        writings.insert(Writing(question: questions[6]), at: 2)
        
        // Mother Lang Listening Writing
        writings.insert(Writing(question: questions[7]), at: 3)
        
        return writings
    }
    
    public func getMultipleSelections() -> [MultipleSelection] {
        return multipleSelections
    }
    
    public func getMultipleSelection(withIndex index: Int) -> MultipleSelection {
        return multipleSelections[index]
    }
    
    public func getWritings() -> [Writing] {
        return writings
    }
    
    public func getWriting(withIndex index: Int) -> Writing {
        return writings[index]
    }
    
    public func getType(forIndex index: Int) -> QuestionType {
        if index < 4 {
            return QuestionType.reading
        } else {
            return QuestionType.listening
        }
    }
    
    public func isLearned() -> Bool {
        
        return !multipleSelections[0].isAnswered() || !multipleSelections[1].isAnswered() || !multipleSelections[2].isAnswered() || !multipleSelections[3].isAnswered() || !writings[0].isAnswered() || !writings[1].isAnswered() || !writings[2].isAnswered() || !writings[3].isAnswered()
    }
    
    public func askMultipleSelection(withIndex index: Int) {
        if !multipleSelections[index].isAnswered() {
            
            print("\nquestion \(index) \(multipleSelections[index].getQuestion().getLanguage()) \(multipleSelections[index].getQuestion().getType()) multiple selection  - \(multipleSelections[index].getQuestion().getText())")
            
            multipleSelections[index].printAnswers()
            
            print("Bir şık seçin:")
            
            let selectedAnswerIndex = Int(readLine() ?? "0")!
            
            print("Answer = \(multipleSelections[index].answerTheQuestion(answerIndex: selectedAnswerIndex))")
        }
    }
    
    public func askWriting(withIndex index: Int) {
        if !writings[index].isAnswered() {
            
            print("\nquestion \(index) \(writings[index].getQuestion().getLanguage()) \(writings[index].getQuestion().getType()) writing \(writings[index].getQuestion().getText())")
            
            print("Bir cevap girin: ")
            
            let writingAnswer = "\(readLine() ?? "")"
            
            print("Girilen Cevap: \(writingAnswer)")
            
            print("Doğru Cevap: \(writings[index].getQuestion().getRightAnswer())")
            
            writings[index].answerTheQuestion(text: writingAnswer)
            
            print("Answer = \(writings[index].checkAnswer())")
            
        }
    }
    
    public func askQuestion(withAnswerType answerType: AnswerType, withLanguageType languageType: LanguageType, andQuestionType questionType: QuestionType) {
        switch answerType {
        case .multipleSelection:
            switch languageType {
            case .foreign:
                switch questionType {
                case .reading: askMultipleSelection(withIndex: 0)
                case .listening: askMultipleSelection(withIndex: 2)
                }
            case .mother:
                switch questionType {
                case .reading: askMultipleSelection(withIndex: 1)
                case .listening: askMultipleSelection(withIndex: 3)
                }
            }
        case .writing:
            switch languageType {
            case .foreign:
                switch questionType {
                case .reading: askWriting(withIndex: 0)
                case .listening: askWriting(withIndex: 2)
                }
            case .mother:
                switch questionType {
                case .reading: askWriting(withIndex: 1)
                case .listening: askWriting(withIndex: 3)
                }
            }
        }
        
    }
}

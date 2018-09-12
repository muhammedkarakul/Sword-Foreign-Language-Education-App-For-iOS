//
//  Writing.swift
//  SwordLearnAlgorithm
//
//  Created by Muhammed Karakul on 23.08.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class Writing {
    private var question: Question
    private var answer: Answer
    
    init() {
        question = Question()
        answer = Answer()
    }
    
    init(question: Question, answer: Answer) {
        self.question = question
        self.answer = answer
    }
    
    public func getQuestion() -> Question {
        return question
    }
    
    public func answerTheQuestion(withText text: String) -> Bool {
        let isAnswerCorrect = answer.getText(withType: question.getType()) == text
        if !isAnswerCorrect {
            question.increaseWrongAnswerCounter()
            question.checkWrongAnswerCounter()
        } else {
            question.setAnswerState(state: isAnswerCorrect)
        }

        return isAnswerCorrect
    }
    
    public func isAnswered() -> Bool {
        return question.getAnswerState()
    }
}

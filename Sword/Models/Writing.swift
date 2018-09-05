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
    
    init(question: Question) {
        self.question = question
        self.answer = Answer()
    }
    
    public func getQuestion() -> Question {
        return question
    }
    
    public func setAnswer(answer: Answer) {
        self.answer = answer
    }
    
    public func answerTheQuestion(text: String) {
        answer.setText(text: text)
    }
    
    public func checkAnswer() -> Bool {
        let isAnswerCorrect = answer.getText(withType: question.getType()) == question.getRightAnswer()
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

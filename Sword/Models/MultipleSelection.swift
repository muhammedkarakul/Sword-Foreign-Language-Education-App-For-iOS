//
//  Quiz.swift
//  SwordLearnAlgorithm
//
//  Created by Muhammed Karakul on 22.08.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class MultipleSelection {
    private var question: Question
    private var answers: [Answer]
    
    init() {
        question = Question()
        answers = [Answer]()
    }
    
    init(question: Question) {
        self.question = question
        self.answers = [Answer]()
    }
    
    public func getQuestion() -> Question {
        return question
    }
    
    public func getAnswers() -> [Answer] {
        return answers
    }
    
    /**
     * This method create answers for quiz.
     * - parameter words: Source of answers.
     */
    public func createAnswers(words: [Word]) {
        
        // Add right answer to answers array.
        addRightAnswerToAnswers(fromWordsArray: words)
        
        // Add wrong answers to answers array.
        addWrongAnswerToAnswers(withWrongAnswerNumber: 3, andSourceWords: words)
        
        // shuffle answers array.
        answers = answers.shuffled()
    }
    
    private func addRightAnswerToAnswers(fromWordsArray words: [Word]) {
        for word in words {
            if word.getId() == question.getWord().getId() {
                let rightAnswer = Answer(word: word, language: question.getLanguage())
                answers.append(rightAnswer)
            }
        }
    }
    
    private func addWrongAnswerToAnswers(withWrongAnswerNumber number: Int, andSourceWords words: [Word]) {
        while(answers.count < number + 1) {
            let randomNumber = Int(arc4random_uniform(UInt32(words.count)))
            if words.count > 0 {
                let answer = Answer(word: words[randomNumber], language: question.getLanguage())
                if isAnswerUnique(compareAnswer: answer) {
                    answers.append(answer)
                }
            }
        }
    }
    
    private func isAnswerUnique(compareAnswer: Answer) -> Bool {
        var isUnique = true
        if answers.count > 0 {
            for answer in answers {
                if answer.getWord().getId() == compareAnswer.getWord().getId(){
                    isUnique = false
                }
            }
        }
        return isUnique
    }
    
    public func answerTheQuestion(answerIndex: Int) -> Bool {
        let isAnswerCorrect = answers[answerIndex].getWord().getId() == question.getWord().getId()
        
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
    
    public func printAnswers() {
        for answer in answers {
            print(answer.getText(withType: question.getType()))
        }
    }
}

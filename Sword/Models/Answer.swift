//
//  Answer.swift
//  SwordLearnAlgorithm
//
//  Created by Muhammed Karakul on 22.08.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation

class Answer {
    private var word: Word
    private var language: LanguageType
    
    init() {
        word = Word()
        language = LanguageType.foreign
    }
    
    init(word: Word, language: LanguageType) {
        self.word = word
        self.language = language
    }
    
    public func getWord() -> Word {
        return word
    }
    
    public func getText(withType type: QuestionType) -> String {
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
    
    public func setText(text: String) {
        switch language {
        case .mother: word.setMotherLang(motherLang: text)
        case .foreign: word.setForeignLang(foreignLang: text)
        }
    }
    
}

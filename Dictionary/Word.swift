//
//  Volcabulary.swift
//  Dictionary
//
//  Created by Thao Le on 6/4/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Word: Object {
    @objc dynamic var wid: String = UUID().uuidString
    @objc dynamic var vocabulary: String  = ""
    @objc dynamic var usedInSentence: String = ""
    @objc dynamic var translation: String = ""
    @objc dynamic var speech: String = ""
    @objc dynamic var date: Date = Date.init()
    
    override static func primaryKey() -> String? {
        return "wid"
    }
    
    func duplicate() -> Word {
        let word: Word = Word()
        
        word.wid = wid
        word.vocabulary = vocabulary
        word.usedInSentence = usedInSentence
        word.translation = translation
        word.speech = speech
        word.date = date
        
        return word
    }
}

//
//  WordManager.swift
//  Dictionary
//
//  Created by Thao Le on 6/6/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

@objc protocol WordManagerSubscriber {
    func subscriberId() -> String
    @objc optional func didDeleteWord(wid: String)
    @objc optional func didAddWord(word: Word)
    @objc optional func didSavedInSentence(wid: String, content: String)
}

class WordManager {
    public static let manager: WordManager = WordManager.init()
    var subscribers: [WordManagerSubscriber] = []
    
    init() {}
    
    func subscribe(subscriber: WordManagerSubscriber) {
        subscribers.append(subscriber)
    }
    
    func unSubscribe(object: WordManagerSubscriber) {
        for i in 0..<subscribers.count {
            if subscribers[i].subscriberId() == object.subscriberId(){
                subscribers.remove(at: i)
                break
            }
        }
    }
    
    private func didDeleteWord(wid: String) {
        for subscriber in subscribers {
            subscriber.didDeleteWord?(wid: wid)
        }
    }
    
    private func didAddWord(word: Word) {
        for subsriber in subscribers {
            subsriber.didAddWord?(word: word)
        }
    }
    
    func didSavedInSentence(wid: String, content: String) {
        for subscriber in subscribers {
            subscriber.didSavedInSentence?(wid: wid, content: content)
        }
    }
    
    func saveWord(word: Word) {
        guard let realm = try? Realm.init() else { return }
        try? realm.write {
            realm.add(word)
        }
        didAddWord(word: word)
    }
    
    func deleteWord(id: String){
        guard let realm = try? Realm.init(), let targetWord = realm.objects(Word.self).filter({ $0.wid == id }).first else {return}
        try? realm.write {
           realm.delete(targetWord)
        }
        
        didDeleteWord(wid: id)
    }
    
    func savedWithContent(id: String, content: String) {
        guard let realm = try? Realm(), let targetWord = realm.objects(Word.self).filter({$0.wid == id}).first else {return}
        try? realm.write {
            targetWord.usedInSentence = content
        }
        didSavedInSentence(wid: id, content: content)
    }
    
    func fetchWord() -> [Word] {
        let realm = try? Realm.init()
        return realm?.objects(Word.self).map { $0.duplicate() } ?? []
    }
}

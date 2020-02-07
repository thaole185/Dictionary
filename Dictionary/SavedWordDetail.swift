//
//  SavedWordDetail.swift
//  Dictionary
//
//  Created by Thao Le on 7/4/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit

class SavedWordDetail: UIViewController {
    
    @IBOutlet weak var wordDisplay: UILabel!
    @IBOutlet weak var wordMeaning: UILabel!
    @IBOutlet weak var usedInSentance: UILabel!
    
    let word: Word = Word.init()
    
    override func viewDidLoad() {
        wordDisplay.text = word.vocabulary.capitalized
        wordMeaning.text = word.translation
        
        if(word.usedInSentence.isEmpty) {
            usedInSentance.text = "None"
        }
        else {
            usedInSentance.text = word.usedInSentence
        }
    }
}

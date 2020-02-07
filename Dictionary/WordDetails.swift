//
//  WordDetails.swift
//  Dictionary
//
//  Created by Thao Le on 6/10/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import FirebaseAuth
import RealmSwift
import AVFoundation

class WordDetail: UIViewController {
    
    let viewID: String = UUID().uuidString
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init()
    
    @IBOutlet weak var wordToSearch: UITextField!
    @IBOutlet weak var speaker: UIButton!
    @IBOutlet weak var wordMeaning: UILabel!
    @IBOutlet weak var wordDisplay: UILabel!
    @IBOutlet weak var savedWith: UITextField!
    
    var sourceCode = ""
    var targetCode = ""
    var word = ""
    var languageCode = ""
    var name = ""
    var volID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordToSearch.text = word  // Ask, can string be assigned to String? here
        
        searchClicked(self)
        
        WordManager.manager.subscribe(subscriber: self)
        
        activityIndicator.center = savedWith.center
        activityIndicator.hidesWhenStopped = true  // we want to hide this when we click stop
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        guard let volcabulary = wordToSearch.text else { return }

        if(UtilityFunctions.isEmpty(s: volcabulary)) {
            return
        }

        UtilityFunctions.searchForWord(volcabulary: volcabulary, sourceCode: sourceCode, targetCode: targetCode, languageCode: languageCode, name: name){ (str) -> Void in
            self.wordMeaning.text = str[0]
            self.wordDisplay.text = volcabulary.capitalized
            let word: Word = Word()
            if(str[0] != volcabulary) {
                self.volID = str[2]
                word.wid = str[2]
                word.speech = str[1]
                word.translation = str[0]
                word.vocabulary = volcabulary
                WordManager.manager.saveWord(word: word)
            }
        }

    }

    @IBAction func speakerPressed(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: wordToSearch.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "vi-GB")
        utterance.rate = 0.1

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        guard let content = savedWith.text else {return}
        if(UtilityFunctions.isEmpty(s: content)) {
            return
        }
        UtilityFunctions.savedInSentence(content: content, wid: volID)
        WordManager.manager.savedWithContent(id: volID, content: content)
        
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        let popUp = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpSB")
        popUp.modalTransitionStyle = .crossDissolve
        popUp.modalPresentationStyle = .overFullScreen
        present(popUp, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                popUp.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension WordDetail: WordManagerSubscriber {
    func subscriberId() -> String {
        return viewID
    }
}

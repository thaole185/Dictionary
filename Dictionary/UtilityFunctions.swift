//
//  UtilityFunctions.swift
//  Dictionary
//
//  Created by Thao Le on 6/2/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Alamofire

class UtilityFunctions {
    
    init() {}
    
    public static func isEmpty(s: String) -> Bool {
        var text: String = s.replacingOccurrences(of: " ", with: "")
        text = text.replacingOccurrences(of: "\n", with: "")
        return text.isEmpty
    }
    
    public static func searchForWord (volcabulary: String, sourceCode: String, targetCode: String, languageCode: String, name: String, handler: @escaping ([String]) -> Void)
    {
        
        var finalResult: [String] = []
        
        Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
            guard let token = token else { return }
            print(token)
            
            Alamofire.request("https://us-central1-dictionary-d0753.cloudfunctions.net/searchForWord",
                              method: .post,
                              parameters: ["vocabulary": volcabulary,
                                           "sourceCode": sourceCode,
                                           "targetCode": targetCode,
                                           "languageCode": languageCode,
                                           "name": name],
                              encoding: JSONEncoding.default,
                              headers: ["Authorization": "Bearer \(token)"])
                .responseJSON(completionHandler: { (result) in
                    guard let data = result.value,
                        let dict = data as? [String: Any],
                        let audio = dict["audioContent"] as? String,
                        let translation = dict["translations"] as? [[String: String]],
                        let wid = dict["wid"] as? String,
                        let meaning = translation[0]["translatedText"]  else { return }
                
                        finalResult.append(meaning)
                        finalResult.append(audio)
                        finalResult.append(wid)
                    handler(finalResult)
                   
                })
        })
        
    }
    
    public static func savedInSentence(content: String, wid: String) {
        Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
            guard let token = token else {return}
            
            Alamofire.request("https://us-central1-dictionary-d0753.cloudfunctions.net/updateWord",
                              method: .post,
                              parameters: ["wid": wid, "inContent": content],
                              encoding: JSONEncoding.default,
                              headers: ["Authorization": "Bearer \(token)"])
            
            
        })
    }
    
    public static func deleteWord (wid: String) {
                Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
                    guard let token = token else {return}
                    Alamofire.request("https://us-central1-dictionary-d0753.cloudfunctions.net/deleteWord",
                                      method: .post,
                                      parameters: ["wid": wid],
                                      headers: ["Authorization": "Bearer \(token)"])
                })
    }
    

    
}

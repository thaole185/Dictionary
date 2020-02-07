//
//  User.swift
//  Dictionary
//
//  Created by Thao Le on 5/30/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var uid: String = UUID.init().uuidString
    @objc dynamic var email: String = ""
    @objc dynamic var pass: String = ""
    @objc dynamic var autoSignedIn: Bool = false
    
    override static func primaryKey () -> String? {
        return "uid"
        
    }
}

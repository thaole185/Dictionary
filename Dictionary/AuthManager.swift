//
//  AuthManager.swift
//  Dictionary
//
//  Created by Thao Le on 5/30/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import RealmSwift

protocol AuthSubsriber {
    func subsriberId() -> String
    func onStateChange()
}

class AuthManager {
    public static let manager: AuthManager = AuthManager.init()
    var subsribers: [AuthSubsriber] = []
    
    private init() {}
    
    func subsribe(subsriber: AuthSubsriber) {
        subsribers.append(subsriber)
    }
    
    func unsubsribe(subsriber: AuthSubsriber) {
        for i in 0 ..< subsribers.count {
            if (subsribers[i].subsriberId() == subsriber.subsriberId()){
                subsribers.remove(at: i)
            }
        }
    }
    
    func getCurrentUSer() -> User? {
        guard let realm = try? Realm.init() else { return nil }
        return realm.objects(User.self).first
    }
    
    func setCurrentUser(user: User) {
        guard let realm = try? Realm.init() else { return }
        try? realm.write {
            guard let previousUser = realm.objects(User.self).first else {
                realm.add(user)
                realm.delete(realm.objects(Word.self))
                return
                
            }
            if(previousUser.uid != user.uid){
                realm.delete(realm.objects(Word.self))
                realm.delete(previousUser)
                realm.add(user)
            }
        }
        
        onStateChange()
    }
    
    func onStateChange() {
        for i in 0 ..< subsribers.count {
            subsribers[i].onStateChange()
        }
    }

}

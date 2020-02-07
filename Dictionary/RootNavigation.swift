//
//  RootNavigation.swift
//  Dictionary
//
//  Created by Thao Le on 5/29/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit

class RootNavigation: UINavigationController, AuthSubsriber {
  
    let id: String = UUID.init().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthManager.manager.subsribe(subsriber: self)
        
        if AuthManager.manager.getCurrentUSer()?.autoSignedIn ?? false {
            performSegue(withIdentifier: Segue.tabBar.rawValue, sender: nil)
        } else {
            performSegue(withIdentifier: Segue.login.rawValue, sender: nil)
        }
    }
    
    func onStateChange() {
        if AuthManager.manager.getCurrentUSer() == nil {
            performSegue(withIdentifier: Segue.login.rawValue, sender: nil)
        } else {
            performSegue(withIdentifier: Segue.tabBar.rawValue, sender: nil)
        }
    }
    
    func subsriberId() -> String {
        return id
    }
    
    
}


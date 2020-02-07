//
//  File.swift
//  Dictionary
//
//  Created by Thao Le on 5/30/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

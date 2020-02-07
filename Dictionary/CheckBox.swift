//
//  CheckBox.swift
//  Dictionary
//
//  Created by Thao Le on 5/27/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    let checkedImage = UIImage(named: "checked")
    let uncheckedImage = UIImage.init(named: "unchecked")
    
    var isChecked: Bool = false {
        didSet {
            if self.isChecked == true {
                self.setImage(checkedImage, for: .normal)
            }
            else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc
    func buttonClicked(sender: UIButton) {
        if(sender == self){
            if(isChecked == false) {
                isChecked = true
            }
            else {
                isChecked = false
            }
        }
    }

}

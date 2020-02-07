//
//  VietToEng.swift
//  Dictionary
//
//  Created by Thao Le on 6/2/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit

class VietToEng: UIViewController {

    @IBOutlet weak var searchBar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(searchBar.text != "") {  // ask, when to use guard for searchBar.text
            searchBar.text = ""
        }
    }
    
    
    @IBAction func searchClicked(_ sender: Any) {
        guard let word = searchBar.text else { return }
        if(!UtilityFunctions.isEmpty(s: word)) {
            performSegue(withIdentifier: "GoToWordDetailFromVE", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoToWordDetailFromVE") {
            guard let destination = segue.destination as? WordDetail, let word = searchBar.text else { return }
            destination.word = word
            destination.sourceCode = "vi"
            destination.targetCode = "en"
            destination.languageCode = "vi-VN"
            destination.name = "vi-VN-Standard-A"
        }
    }
}

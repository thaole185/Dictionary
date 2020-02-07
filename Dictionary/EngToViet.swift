//
//  File.swift
//  Dictionary
//
//  Created by Thao Le on 5/30/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit

class EngToViet: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 15
        searchButton.layer.cornerRadius = 15
        
    }
    
    override func viewWillAppear(_ animated: Bool) {  // viewDidLoad is only called once. viewWillAppear called every single time. However, the whole view that were created using viewDidLoad is still there, viewWillAppear just run code that you want it to run
        if(searchBar.text != "") {
            searchBar.text = ""
        }
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func searchClicked(_ sender: Any) {
         guard let word = searchBar.text else { return }
        if(!UtilityFunctions.isEmpty(s: word)) {
            performSegue(withIdentifier: "GotoWordDetailFromEV", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GotoWordDetailFromEV") {
            guard let destination = segue.destination as? WordDetail else { return }
            guard let word = searchBar.text else { return }
            destination.word = word
            destination.sourceCode = "en"
            destination.targetCode = "vi"
            destination.languageCode = "vi-VN"
            destination.name = "vi-VN-Standard-A"
        }
    }

}

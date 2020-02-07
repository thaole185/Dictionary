//
//  Signup.swift
//  Dictionary
//
//  Created by Thao Le on 5/29/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Alamofire

class Signup: UIViewController, AuthSubsriber {

    let viewId: String = UUID().uuidString
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init()
    
    @IBOutlet weak var warning: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthManager.manager.subsribe(subsriber: self)
        
        activityIndicator.center = view.center
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    @IBAction func register(_ sender: Any) {
        
        warning.text = ""
        
        guard let useremail = email.text, let userpass = pass.text else { return }
        
        if (UtilityFunctions.isEmpty(s: useremail) && UtilityFunctions.isEmpty(s: userpass)) {
            warning.text = "Please enter valid informations"
            email.text = ""
            pass.text = ""
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: useremail, password: userpass) { (result, error) in
            guard let user = result?.user else {
                self.warning.text = "Invalid user! Try again."
                self.email.text = ""
                self.pass.text = ""
                return
            }
            
            Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
                guard let token = token else { return }
                
                Alamofire.request("https://us-central1-dictionary-d0753.cloudfunctions.net/setUser",
                                  method: HTTPMethod.post,
                                  headers: ["Authorization": "Bearer \(token)"])
                    .response(completionHandler: { (result) in
                        guard let _ = result.data else
                        { self.warning.text = "Something went wrong"
                        return }
                        
                        let curerentUser: User = User()
                        curerentUser.uid = user.uid
                        curerentUser.email = useremail
                        curerentUser.pass = userpass
                        
                        AuthManager.manager.setCurrentUser(user: curerentUser)
                        self.dismiss(animated: true, completion: nil)
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    })
                
            })
        }

    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func subsriberId() -> String {
        return viewId
    }
    
    func onStateChange() {
        
    }
}




//
//  ViewController.swift
//  Dictionary
//
//  Created by Thao Le on 5/18/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire

class SignIn: UIViewController, AuthSubsriber {

//    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var signIn: UILabel!
    let viewId: String = UUID().uuidString
    
    @IBOutlet weak var warning: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signedInButton: CheckBox!
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let array = userSelectedString?.split(separator: "="), let selected = array.last {
//            label.text = String(selected)
//        } else {
//            label.text = "You didn't select anything"
//        }
        
        AuthManager.manager.subsribe(subsriber: self)
        
        guard let currentUser = AuthManager.manager.getCurrentUSer() else { return }
        if(currentUser.autoSignedIn) {
            performSegue(withIdentifier: Segue.tabBar.rawValue, sender: self)
        }
        
        activityIndicator.center = view.center
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        warning.text = ""
        
        guard let signedIn = signedInButton.currentImage, let uname: String = username.text, let upass: String = password.text else { return }
        
        if(UtilityFunctions.isEmpty(s: uname) && UtilityFunctions.isEmpty(s: upass)){
            warning.text = "Invalid Input. Try again!"
        }
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        Auth.auth().signIn(withEmail: uname, password: upass) { (result, error) in
            guard let user = result?.user
                else { self.warning.text = "Invalid Information. Try again"
                    return }
            let currentUser: User = User()
            currentUser.email = uname
            currentUser.pass = upass
            currentUser.uid = user.uid
            if(signedIn.isEqual(UIImage(named: "checked"))){
                currentUser.autoSignedIn = true
            }
            
            AuthManager.manager.setCurrentUser(user: currentUser)
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            // self.navigationController?.performSegue(withIdentifier: Segue.tabBar.rawValue, sender: nil)
        }
    }
    @IBAction func signup(_ sender: Any) {
        performSegue(withIdentifier: "Signup", sender: self)
    }
    
    func subsriberId() -> String {
        return viewId
    }
    
    func onStateChange() {
        
    }
}

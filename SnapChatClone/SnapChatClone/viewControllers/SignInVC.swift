//
//  ViewController.swift
//  SnapChatClone
//
//  Created by Büşra Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Busra Serdaroglu. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(_ sender: Any) {
        if passwordText.text != ""
            && emailText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Unknown error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
             
        } else {
            self.makeAlert(title: "Error", message: "Username/Password/Email is empty")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if usernameText.text != ""
            && passwordText.text != ""
            && emailText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (auth, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Unknown Error")
                } else {
                    let fireStore = Firestore.firestore()
                
                    let userDictionary = ["email" : self.emailText.text!, "username" : self.usernameText.text!]
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil {
                            
                        } else {
                            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                        }
                    }
                }
            }
        } else {
            self.makeAlert(title: "Error", message: "Username/Password/Email is empty")
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}


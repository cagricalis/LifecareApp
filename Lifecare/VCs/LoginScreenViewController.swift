//
//  LoginScreenViewController.swift
//  Lifecare
//
//  Created by cagri calis on 6.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginScreenViewController: UIViewController {

    @IBAction func loginButton(_ sender: Any) {
        
        if (emailTextField.text == " " || passwordTextField.text == " ") {
            
            let alertController = UIAlertController(title: "Error", message: "Fill all infos", preferredStyle: .alert)
            let defaultAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAlert)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    print("Login Successful")
                    if let user = user {
                    
                    self.completeSignIn(id: user.uid)
                        
                        let keychainResult = KeychainWrapper.standard.set((user.uid), forKey: KEY_UID)
                        print("CAGRI: Data saved to keychain \(keychainResult)")
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
                        self.present(vc!, animated: true, completion: nil)
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAlert)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func emailTextField(_ sender: Any) {
    }
    @IBAction func passwordTextField(_ sender: Any) {
    }
    @IBOutlet weak var emailTextField: customTextField!
    @IBOutlet weak var passwordTextField: customTextField!
    
    @IBAction func forgotPassword(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10.0
        self.hideKeyboardWhenTappedAround()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func completeSignIn(id: String, userData: Dictionary<String, Any>) {
//        //DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
//        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
//        print("Data saved to keychain \(keychainResult)")
//        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
//        //self.present(vc!, animated: true, completion: nil)
//    }
    
    func completeSignIn(id: String) {
        //DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult)")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    

}

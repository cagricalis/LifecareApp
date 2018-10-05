//
//  SignUpViewController.swift
//  Lifecare
//
//  Created by cagri calis on 6.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class customTextField : UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.4).cgColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.4)
        self.tintColor = UIColor.white
    }
}

class SignUpViewController: UIViewController {
    
    let barButtonAppearence = UIBarButtonItem.appearance()

    @IBAction func nameTextField(_ sender: Any) {
        
    }
    @IBAction func surnameTextField(_ sender: Any) {
        
    }
    @IBAction func emailTextField(_ sender: Any) {
        
    }
    @IBAction func passwordTextField(_ sender: Any) {
        
    }
    
    @IBOutlet weak var nameTextField: customTextField!
    @IBOutlet weak var surnameTextField: customTextField!
    @IBOutlet weak var emailTextField: customTextField!
    @IBOutlet weak var passwordTextField: customTextField!
    
    @IBAction func backButton(_ sender: Any) {
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if (emailTextField.text == "" || passwordTextField.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Please fill the information correctly", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                
                
                
                if error == nil {
                    print("Succesfully SignIn")
                    

                            if let user = user {
                                
                                if let firstName = self.nameTextField.text, let lastName = self.surnameTextField.text, let email = self.emailTextField.text {
                                    
                                    
                                    
                                    let signUpData = ["emailAdress": email, "accountID": user.uid, "firstName": firstName, "lastName": lastName]
                                    
                                    DataService.ds.createUserInfoInDB(user.uid, signUpData: signUpData)
                                    
                                    
                                    
                                }
                                
                                let keychainResult = KeychainWrapper.standard.set((user.uid), forKey: KEY_UID)
                                print("CAGRI: Data saved to keychain \(keychainResult)")
                                
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController")
                                self.present(vc!, animated: true, completion: nil)
                                
                            }
                            
                            //1111
                           // self.performSegue(withIdentifier: "pageView", sender: sender)
                            //1111
                            
                            //MARK: It will be deleted
                            

                    
                    
                    
                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PageViewScreenViewController")
//                    self.present(vc!, animated: true, completion: nil)
                    
                    //11111111
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            })
            
        }
        
        
    }
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 10
        self.hideKeyboardWhenTappedAround()
    
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let backItem = UIBarButtonItem()
//        backItem.title = "Back"
//        navigationItem.backBarButtonItem = backItem
//    }
    
    
    



}

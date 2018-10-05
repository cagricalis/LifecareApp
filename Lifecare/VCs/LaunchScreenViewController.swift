//
//  LaunchScreenViewController.swift
//  Lifecare
//
//  Created by cagri calis on 6.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBAction func signUpButton(_ sender: Any) {
        
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func englishTranslateButton(_ sender: Any) {
    }
    @IBAction func turkishTranslateButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
          self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
          self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
          let backButton = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        
        loginButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
//  Page4ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 6.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import Firebase

class Page4ViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func finishPageControllerButton(_ sender: Any) {
        
        Variables.generalDictionary.updateValue("Lütfen Giriniz...", forKey: "Şehir")
        
        DataService.ds.REF_USER_CURRENT.child("personal").setValue(Variables.generalDictionary)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var finishPageControllerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        
        profilePicture.layer.cornerRadius = 30
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

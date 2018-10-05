//
//  Page1ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 6.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import Firebase

class Page1ViewController: UIViewController {
    
    //woman = 1
    //man = 0
    
    var sex:Int = 0
    let boyImage = UIImage(named: "boy")
    let boyGrayImage = UIImage(named: "boyGray")
    let girlImage = UIImage(named: "girl")
    let girlGrayImage = UIImage(named: "girlGray")
    
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var manButton: UIButton!
    
   
    
    @IBAction func womanButton(_ sender: Any) {
        
        if sex == 0 {
        

            manButton.setImage(boyGrayImage, for: .normal)
            womanButton.setImage(girlImage, for: .normal)
            Variables.generalDictionary.updateValue("Kadın", forKey: "Cinsiyet")
            print(Variables.generalDictionary)
         
            sex = 1
        } else {
          manButton.setImage(boyGrayImage, for: .normal)
            Variables.generalDictionary.updateValue("Erkek", forKey: "Cinsiyet")
        }
        print(sex)
        
    }
    @IBAction func manButton(_ sender: Any) {
        if sex == 1 {

            manButton.setImage(boyImage, for: .normal)
            womanButton.setImage(girlGrayImage, for: .normal)
            Variables.generalDictionary.updateValue("Erkek", forKey: "Cinsiyet")
            print(Variables.generalDictionary)
           
            sex = 0
        } else {
            womanButton.setImage(girlGrayImage, for: .normal)
            Variables.generalDictionary.updateValue("Kadın", forKey: "Cinsiyet")
        }
         print(sex)
    }
    
    @IBAction func selectButton(_ sender: Any) {
        
        
        //MARK: next page
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

//
//  Page3ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 6.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit

class Page3ViewController: UIViewController {

    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBAction func selectButton(_ sender: Any) {
        
        Variables.generalDictionary.updateValue("\(heightTextField.text!)", forKey: "Boy")
        Variables.generalDictionary.updateValue("\(weightTextField.text!)", forKey: "Kilo")
        print(Variables.generalDictionary)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

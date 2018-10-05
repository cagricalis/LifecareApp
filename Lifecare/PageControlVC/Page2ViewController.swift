//
//  Page2ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 6.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit

class Page2ViewController: UIViewController {
    
    var userBirthday = String()
    
    @IBAction func datePickerChanged(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let userBirthday = dateFormatter.string(from: datePicker.date)
        self.userBirthday = userBirthday
        
        
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func selectButton(_ sender: Any) {
        
        Variables.generalDictionary.updateValue("\(self.userBirthday)", forKey: "Doğum Tarihi")
        print(Variables.generalDictionary)
        
        //MARK: Send firebase
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



//MARK: If you want to use custom datepicker, I added SCPopDatePicker library, also you can find example class for that


/* class Page2ViewController: UIViewController, SCPopDatePickerDelegate {

    let datePicker = SCPopDatePicker()
    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.tapToDismiss = true
        self.datePicker.datePickerType = SCDatePickerType.date
        self.datePicker.showBlur = true
        self.datePicker.datePickerStartDate = self.date
        self.datePicker.btnFontColour = UIColor.white
        self.datePicker.btnColour = UIColor.darkGray
        self.datePicker.showCornerRadius = false
        self.datePicker.delegate = self
        self.datePicker.show(attachToView: self.view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scPopDatePickerDidSelectDate(_ date: Date) {
        print(date)
    }

} */

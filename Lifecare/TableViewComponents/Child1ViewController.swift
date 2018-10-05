//
//  Child1ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 9.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase



class Child1ViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    var generalDictionary = [String : String]()
    
    var testArray = ["Cinsiyet", "Doğum Tarihi", "Boy", "Kilo", "Şehir"]
    var detailedArray = ["Erkek", "01.01.1990", "180", "80", "Ankara"]
    
   
    
    

    var ref:DatabaseReference!
    
    @IBOutlet weak var child1TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setGeneralDictionary()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Kişisel")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = child1TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Child1TableViewCell
        
        cell.title.text = testArray[indexPath.row]
        cell.detail.text = detailedArray[indexPath.row]

        return cell
    }
    let vw = UIView()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        child1TableView.deselectRow(at: indexPath, animated: true)
       
        let alert = UIAlertController(title: "\(self.testArray[indexPath.row])", message: "Enter text below", preferredStyle: .alert)
 
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(String(describing: textField?.text))")
           
            //let general_key = self.generalDictionary.index(forKey: "\(self.testArray[indexPath.row])")
            //print(general_key!)
            print(self.testArray[indexPath.row])
            self.generalDictionary.updateValue((textField?.text)!, forKey: self.testArray[indexPath.row])
            print(self.generalDictionary)
            Variables.generalDictionary = self.generalDictionary
            
            DataService.ds.REF_USER_CURRENT.child("personal").setValue(self.generalDictionary)
            //DataService.ds.createFirebaseDBUser(KEY_UID, userData: self.generalDictionary)
            self.setGeneralDictionary()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func setGeneralDictionary() {
        
        DataService.ds.REF_USER_CURRENT.child("personal").observe(.value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print(value!)
            self.generalDictionary = value as! [String : String]
            
            self.testArray.removeAll()
            self.detailedArray.removeAll()
            
            
            for (key, value) in self.generalDictionary {
                
                self.testArray.append(key)
                self.detailedArray.append(value)
            }
            
            self.child1TableView.reloadData()
            
            
        }
    }
    


}

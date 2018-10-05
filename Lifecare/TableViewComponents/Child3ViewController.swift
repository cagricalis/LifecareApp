//
//  Child3ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 10.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Child3ViewController: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate {
    
    let testArray = ["Öğün düzeni", "Atlanan öğün", "Ara öğün alışkanlığı", "Atıştırma alışkanlığı", "Dışarda yemek yeme", "Gece yemek alışkanlığı", "Günlük su tüketimi", "Sabah kahvaltısı saatiniz", "Öğle yemeği saatiniz", "Akşam yemeği saatiniz"]

    @IBOutlet weak var child3TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Öğün")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = child3TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Child3TableViewCell
      
        
        cell.title.text = testArray[indexPath.row]
        
        return cell
    }
    

}

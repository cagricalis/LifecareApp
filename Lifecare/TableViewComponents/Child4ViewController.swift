//
//  Child4ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 10.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Child4ViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    let testArray = ["Açlık kan şekeri", "İnsülin", "TSH", "D vitamini", "AST-ALT", "Kan yağları", "Çinko", "Ferritin", "B12", "Homo - IR", "Leptin"]

    @IBOutlet weak var child4TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Kan")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = child4TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Child4TableViewCell
        
        
        cell.title.text = testArray[indexPath.row]
        
        return cell
    }
    



}

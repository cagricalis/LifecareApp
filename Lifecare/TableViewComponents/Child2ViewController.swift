//
//  Child2ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 9.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Child2ViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    let testArray = ["Tanısı Konulmamış Hastalığınız", "1.derece akrabanızda kronik hastalık", "Düzenli kullandığınız ilaçlar", "Geçirdiğiniz işlem / Ameliyat", "Besin alerjisi", "Besin intoleransı", "Sigara kullanımı", "Alkol tüketimi", "Aktivite  miktarı"]
    
    @IBOutlet weak var child2TableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Sağlık")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = child2TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Child2TableViewCell
        
        
        cell.title.text = testArray[indexPath.row]
        
        return cell
    }
    

}

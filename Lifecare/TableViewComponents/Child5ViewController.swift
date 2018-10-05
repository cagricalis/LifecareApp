//
//  Child5ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 10.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Child5ViewController: UIViewController, IndicatorInfoProvider {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Ölçüler")
    }
    

    


}

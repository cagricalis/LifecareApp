//
//  Child1TableViewCell.swift
//  Lifecare
//
//  Created by cagri calis on 13.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit

class Child1TableViewCell: UITableViewCell {


    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

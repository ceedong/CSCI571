//
//  favListCell.swift
//  cs571-hw9
//
//  Created by Mark Dong on 11/23/17.
//  Copyright © 2017 Mark Dong. All rights reserved.
//

import UIKit

class favListCell: UITableViewCell {

    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var lastPrice: UILabel!
    @IBOutlet weak var changeAndPercent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

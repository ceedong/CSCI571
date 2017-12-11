//
//  NewsCell.swift
//  cs571-hw9
//
//  Created by Mark Dong on 11/18/17.
//  Copyright © 2017 Mark Dong. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  DateEventTableViewCell.swift
//  FISU
//
//  Created by Reda M on 24/02/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit

class DateEventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    //private var test

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }
}

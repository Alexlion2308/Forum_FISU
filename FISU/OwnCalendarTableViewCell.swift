//
//  OwnCalendarTableViewCell.swift
//  FISU
//
//  Created by Reda M on 27/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit

class OwnCalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabelOwnEvent: UILabel!
    @IBOutlet weak var TimeLabelOwnEvent: UILabel!
    @IBOutlet weak var ImageOwnEvent: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

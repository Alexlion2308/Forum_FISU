//
//  RestoTableViewCell.swift
//  FISU
//
//  Created by Reda M on 05/02/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit

class RestoTableViewCell: UITableViewCell {
    // MARK: Properties

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

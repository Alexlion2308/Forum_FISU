//
//  MaTableVueCellule.swift
//  FISU
//
//  Created by Reda M on 04/02/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit

class MaTableVueCellule: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var MatableVueCell: UIView!

    @IBOutlet weak var Mycellelabel: UILabel!
    

}

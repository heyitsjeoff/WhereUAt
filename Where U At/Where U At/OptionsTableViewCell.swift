//
//  OptionsTableViewCell.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/21/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

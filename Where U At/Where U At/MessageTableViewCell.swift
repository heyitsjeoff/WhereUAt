//
//  MessageTableViewCell.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit

/**
 A UITableViewCell for displaying a message thread
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */
class MessageTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

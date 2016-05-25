//
//  FriendTableViewCell.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit

/**
 A UITableViewCell for displaying friend username
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */
class FriendTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var friendUsername: UILabel!
    
    @IBOutlet weak var newMessageFriendUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

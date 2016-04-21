//
//  FriendTableViewCell.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var friendUsername: UILabel!
    
    @IBOutlet weak var newMessageFriendUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

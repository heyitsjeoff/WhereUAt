//
//  Friend.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit

class Friend {
    //MARK: Properties
    var username: String
    
    init?(username: String){
        self.username = username
        if(username.isEmpty){
            return nil
        }
    }
}

//
//  Friend.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData

/**
 A class to represent a user who can be messaged, of type NSManagedObject
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */
class Friend : NSManagedObject{
    //MARK: - Properties
    @NSManaged var username: String
}

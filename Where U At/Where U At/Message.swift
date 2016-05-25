//
//  Message.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData

/**
 A class to represent a message, of type NSManagedObject
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void

 - version:
 1.0
 */
class Message: NSManagedObject{
    //MARK: - Properties
    
    @NSManaged var senderUsername: String
    @NSManaged var text: String
    @NSManaged var messageID: Int
    @NSManaged var outgoing: Bool
    @NSManaged var location: Bool
}

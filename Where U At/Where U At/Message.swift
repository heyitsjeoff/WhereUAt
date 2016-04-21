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
 Message class
 */
class Message: NSManagedObject{
    //MARK: Properties
    
    @NSManaged var senderUsername: String
    @NSManaged var text: String
    @NSManaged var messageID: Int
    @NSManaged var outgoing: Bool
}

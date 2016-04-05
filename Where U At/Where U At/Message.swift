//
//  Message.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit

/**
 Message class
 */
class Message {
    //MARK: Properties
    
    let senderUsername: String
    let text: String
    let messageID: Int
    let timeSent: String
    
    //MARK: Initialization
    init?(senderUsername: String, text: String, messageID: Int, timeSent: String){
        self.senderUsername = senderUsername
        self.text = text
        self.messageID = messageID
        self.timeSent = timeSent
        
        if(senderUsername.isEmpty || text.isEmpty || messageID < 0 || timeSent.isEmpty){
            return nil
        }
    }
}

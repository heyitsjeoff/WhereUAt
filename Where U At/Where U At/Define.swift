//
//  Define.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/2/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit

var myUsername = ""

/**
 Defined static variables to prevent errors when using them repeatedly
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */
class Variables{
    static let SERVER = "http://152.117.218.105:3000"
    static let WSSERVER = "ws://152.117.218.105:8081"
    static let AUTHENTICATE = SERVER + "/api/authenticate/"
    static let CREATE = SERVER + "/api/create_account/"
    static let SENDFRIENDREQUEST = SERVER + "/api/send_friend_request/"
    static let RESPONDFRIENDREQUEST = SERVER + "/api/respond_friend_request/"
    static let SENDMESSAGE = SERVER + "/api/send_message/"
    static let GETMESSAGE = SERVER + "/api/get_message/"
    static let FAILED = 0
    static let SUCCESS = 1
    static let NOTCONNECTED = 2
}

// MARK: - Functions

/**
 sets myUsername to the string passed in
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - theUsername the username that myUsername will be set to
 
 - version:
 1.0
 */
func setUsername(theUsername: String){
    myUsername = theUsername
}
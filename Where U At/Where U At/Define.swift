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
 static variables used for Where U At. Allows for quick changes without modifying code throughout
*/
class Variables{
    static let SERVER = "http://152.117.218.105:3000"
    static let WSSERVER = "ws://152.117.218.105:8081"
    static let AUTHENTICATE = SERVER + "/api/authenticate/"
    static let CREATE = SERVER + "/api/create_account/"
    static let SENDFRIENDREQUEST = SERVER + "/api/send_friend_request/"
    static let RESPONDFRIENDREQUEST = SERVER + "/api/respond_friend_request/"
    static let FAILED = 0
    static let SUCCESS = 1
    static let NOTCONNECTED = 2
}

// MARK - Functions


func setUsername(theUsername: String){
    myUsername = theUsername
}
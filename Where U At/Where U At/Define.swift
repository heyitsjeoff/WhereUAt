//
//  Define.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/2/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import Foundation

/**
 static variables used for Where U At. Allows for quick changes without modifying code throughout
*/
class Variables{
    static let SERVER = "http://152.117.218.105:3000/"
    static let WSSERVER = "ws://152.117.218.105:3000/"
    static let AUTHENTICATE = "http://152.117.218.105:3000/api/authenticate/"
    static let CREATE = "http://152.117.218.105:3000/api/create_account/"
    static let SENDFRIENDREQUEST = "http://152.117.218.105:3000/api/send_friend_request/"
    static let FAILED = 0
    static let SUCCESS = 1
    static let NOTCONNECTED = 2
}
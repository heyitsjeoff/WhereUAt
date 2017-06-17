//
//  Define.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/2/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

var myUsername = ""

/**
 Defined static variables to prevent errors when using them repeatedly
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */
class Variables{
    static let SERVER = "[server.url.com]"
    static let AUTHENTICATE = SERVER + "/api/authenticate"
    static let CREATE = SERVER + "/api/create_account"
    static let SENDFRIENDREQUEST = SERVER + "/api/send_friend_request"
    static let RESPONDFRIENDREQUEST = SERVER + "/api/respond_friend_request"
    static let GETPENDINGREQUESTS = SERVER + "/api/get_pending_requests"
    static let GETFRIENDSLIST = SERVER + "/api/get_friends_list"
    static let SENDMESSAGE = SERVER + "/api/send_message"
    static let GETMESSAGES = SERVER + "/api/get_messages"
    static let DELETEMESSAGES = SERVER + "/api/delete_messages"
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
 
 Username is also stored as an NSManagedObject, but loading it once and setting it here is much simpler than doing a fetch very often
 */
func setUsername(theUsername: String){
    myUsername = theUsername
}

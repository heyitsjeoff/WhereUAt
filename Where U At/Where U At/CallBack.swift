//
//  CallBack.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/7/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import SwiftyJSON

func signInCallBack(jsonResponse: JSON, theView: SignInViewController){
    print(jsonResponse)
    theView.alertLogin(jsonResponse["success"].stringValue)
}

func createAccountCallBack(jsonResponse: JSON, theView: SignInViewController){
    print(jsonResponse)
    theView.alertCreateAnAcouunt(jsonResponse["success"].stringValue)
}

func sendFriendRequestCallBack(jsonResponse: JSON, theView: FriendTableViewController){
    print(jsonResponse)
    theView.alertSendRequest(jsonResponse["success"].stringValue)
}

func respondFriendRequestCallBack(jsonResponse: JSON, theView: FriendTableViewController, username: String, theResponse: String){
    print(jsonResponse)
    theView.alertRespondRequest(jsonResponse["success"].stringValue, username: username, theResponse: theResponse)
}

func sendMessageCallBack(jsonResponse: JSON, theView: UserMessageViewController, username: String, text: String, location: Bool){
    print(jsonResponse)
    let messageID = jsonResponse["messageID"].intValue
    theView.messageSent(username, text: text, messageID: messageID, location: location)
}

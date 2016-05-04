//
//  CallBack.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/7/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import SwiftyJSON

func signInCallBack(jsonResponse: JSON, theView: SignInViewController){
    theView.alertLogin(jsonResponse["success"].stringValue)
}

func createAccountCallBack(jsonResponse: JSON, theView: SignInViewController){
    theView.alertCreateAnAcouunt(jsonResponse["success"].stringValue)
}

func sendFriendRequestCallBack(jsonResponse: JSON, theView: FriendTableViewController){
    theView.alertSendRequest(jsonResponse["success"].stringValue)
}

func respondFriendRequestCallBack(jsonResponse: JSON, theView: FriendTableViewController, username: String, theResponse: String){
    theView.alertRespondRequest(username)
}

func sendMessageCallBack(jsonResponse: JSON, theView: UserMessageViewController, username: String, text: String, location: Bool){
    let messageID = jsonResponse["messageID"].intValue
    theView.messageSent(username, text: text, messageID: messageID, location: location)
}

func getPendingFriendRequestsCallBack(jsonResponse: JSON, theView: FriendTableViewController){
    let list = jsonResponse[myUsername].arrayValue.map { $0.string!}
    theView.updatePendingRequestsArray(list)
}

func getPendingFriendRequestsCallBack(jsonResponse: JSON){
    let list = jsonResponse[myUsername].arrayValue.map { $0.string!}
    updatePendingRequests(list)
}

func getFriendsListCallBack(jsonResponse: JSON, theView: FriendTableViewController){
    let list = jsonResponse[myUsername].arrayValue.map { $0.string!}
    theView.updateFriendsListArray(list)
}

func getFriendsListCallBack(jsonResponse: JSON){
    let list = jsonResponse[myUsername].arrayValue.map { $0.string!}
    updateFriendsList(list)
}

func getMessagesCallBack(jsonResponse: JSON, theView: UserMessageViewController){
    let list = jsonResponse[myUsername]
    theView.saveJSONMessages(list)
}

func getMessagesCallBack(jsonResponse: JSON){
    let list = jsonResponse[myUsername]
    saveJSONMessages(list)
}

func deleteMessagesFromDatabaseCallBack(jsonResponse: JSON){
    //
}

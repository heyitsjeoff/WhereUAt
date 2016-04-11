//
//  CallBack.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/7/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import Foundation
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
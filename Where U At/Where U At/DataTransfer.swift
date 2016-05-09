//
//  DataTransfer.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/2/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

//import Foundation

/**
 Consists of all the HTTP requests methods which will be using Alamofire.
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 
 Alamofire is asychronus so callbacks are needed to respond appropriately when the JSON is returned.
 Those are defined in CallBack.swift
 */

import Alamofire
import Starscream
import SwiftyJSON
let variables = Variables.self //static variables delcaration

/**
 HTTP request to sign in
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - username: the username used to attempt a sign in
    - password: the password used to attempt a sign in
    - theView: the SignInViewController used to sign in so methods can be called from callback
 
 - version:
 1.0
 
 */
func signIn(username: String, password: String, theView: SignInViewController){
    let credentials = [
        "username": username,
        "password": password
    ]
    
    Alamofire.request(.POST, variables.AUTHENTICATE, parameters: credentials).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            signInCallBack(json, theView: theView)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
        }
}

/**
 HTTP request to create an account
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - username: the username used to create an account
    - password: the password used to create an account
    - theView: the SignInViewController used to create an account so methods can be called from callback
 
 - version:
 1.0
 
 */
func createAccount(username: String, password: String, theView: SignInViewController){
    let credentials = [
        "username": username,
        "password": password
    ]
        
    Alamofire.request(.POST, variables.CREATE, parameters: credentials).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            createAccountCallBack(json, theView: theView)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            
            }
    }
}

/**
 HTTP request to send a friend request
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - username: the username of the person receiving the request
    - theView: the FriendTableViewController used to send the request
 
 - version:
 1.0
 
 */
func sendRequest(username: String, theView: FriendTableViewController){
    let friendRequest = [
        "toUser" : username,
        "fromUser": myUsername
    ]
    
    Alamofire.request(.POST, variables.SENDFRIENDREQUEST, parameters: friendRequest).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            sendFriendRequestCallBack(json, theView: theView)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

/**
 HTTP request to respond to a friend request
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - username: the username of the person who sent the request
    - theResponse: the response to the request
    - theView: the FriendTableViewController used to send the response
 
 - version:
 1.0
 
 */
func sendResponseToRequest(username: String, theResponse: String, theView: FriendTableViewController){
    let friendRequest = [
        "fromUser" : username,
        "toUser": myUsername,
        "acceptStatus": theResponse
    ]
    
    print("friendRequest parameters are: ")
    print(friendRequest)
    
    Alamofire.request(.POST, variables.RESPONDFRIENDREQUEST, parameters: friendRequest).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            respondFriendRequestCallBack(json, theView: theView, username: username, theResponse: theResponse)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

/**
 HTTP request to getPendingRequests
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - theView: the FriendTableViewController used to send the response
 
 - version:
 1.0
 
 */
func getPendingRequests(theView: FriendTableViewController){
    let username = [
        "username" : myUsername
    ]
    
    Alamofire.request(.GET, variables.GETPENDINGREQUESTS, parameters: username).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            getPendingFriendRequestsCallBack(json, theView: theView)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

/**
 HTTP request to get the users friends list
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - theView: the FriendTableViewController used to get the friends list
 
 - version:
 1.0
 
 */
func getFriendsList(theView: FriendTableViewController){
    let username = [
        "username": myUsername
    ]
    
    Alamofire.request(.GET, variables.GETFRIENDSLIST, parameters: username).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            getFriendsListCallBack(json, theView: theView)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

/**
 HTTP request to send a message
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - username: the username of the receiver
    - text: the text of the message
    - location: boolean value for whether or not the message is a location
    - theView: the FriendTableViewController used to send the response
 
 - version:
 1.0
 
 */
func sendMessage(username: String, text: String, location: Bool, theView: UserMessageViewController){
    let message = [
        "sender" : myUsername,
        "receiver" : username,
        "message" : text,
        "mLocation" : location.description
    ]
    Alamofire.request(.POST, variables.SENDMESSAGE, parameters: message).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            sendMessageCallBack(json, theView: theView, username: username, text: text, location: location)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

/**
 HTTP request to get pending messages
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - theView: the UserMessageViewController to get the messages
 
 - version:
 1.0
 
 */
func getMessages(theView: UserMessageViewController){
    let username = [
        "username" : myUsername
    ]
    Alamofire.request(.GET, variables.GETMESSAGES, parameters: username).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            getMessagesCallBack(json, theView: theView)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

/**
 HTTP request to delete messages
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - stringOfIDs: the message ids which are to be deleted
 
 - version:
 1.0
 
 stringOfIDs can have one or more messages
 
 */
func deleteMessagesFromDatabase(stringOfIDs: String){
    let messages = [
        "messageIDs" : stringOfIDs
    ]
    Alamofire.request(.POST, variables.DELETEMESSAGES, parameters: messages).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            deleteMessagesFromDatabaseCallBack(json)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

// MARK: Getters without views

func getPendingRequests(){
    let username = [
        "username" : myUsername
    ]
    
    Alamofire.request(.GET, variables.GETPENDINGREQUESTS, parameters: username).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            getPendingFriendRequestsCallBack(json)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

func getFriendsList(){
    let username = [
        "username": myUsername
    ]
    
    Alamofire.request(.GET, variables.GETFRIENDSLIST, parameters: username).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            getFriendsListCallBack(json)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

func getMessages(){
    let username = [
        "username" : myUsername
    ]
    Alamofire.request(.GET, variables.GETMESSAGES, parameters: username).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            getMessagesCallBack(json)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}
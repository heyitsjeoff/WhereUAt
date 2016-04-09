//
//  DataTransfer.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/2/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import Foundation
import Alamofire
import Starscream
import SwiftyJSON
let variables = Variables.self //static variables delcaration

/**
 Used to sign a user in
 
 @param username the username of the user
 
 @param password the password of the user
 
 @param theView the SignInViewController so we can call functions within their
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
 Used to create an account for a user
 
 @param username the username of the user
 
 @param password the password of the user
 
 @param theView the SignInViewController so we can call functions within their
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
            variables.FAILED
            }
    }
}

/**
 Used to
 
 @param username the username of the user
 
 @param password the password of the user
 
 @param theView the SignInViewController so we can call functions within their
 */
func sendRequest(username: String){
    let friendRequest = [
        "username": username
    ]
    
    Alamofire.request(.POST, variables.SENDFRIENDREQUEST, parameters: friendRequest).responseJSON
        { response in switch response.result {
        case .Success(let jsonRes):
            let json = JSON(jsonRes)
            sendFriendRequestCallBack(json)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            }
    }
}

//
//  CoreDataFunctions.swift
//  Where U At
//
//  Created by Christopher Villanueva on 4/25/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//
import CoreData
import SwiftyJSON

/**
 Consists of Core Data functions for saving
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */

let appDelegate =
    UIApplication.sharedApplication().delegate as! AppDelegate

let managedContext = appDelegate.managedObjectContext


// MARK: - Friends

/**
 Saves a friend to the local storage
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - name: the name of the friend to be saved
 
 - version:
 1.0
 */
func saveFriend(name: String) -> NSManagedObject{
    let entity =  NSEntityDescription.entityForName("Friend",
                                                    inManagedObjectContext:managedContext)
    
    let friend = NSManagedObject(entity: entity!,
                                 insertIntoManagedObjectContext: managedContext)
    friend.setValue(name, forKey: "username")
    
    do {
        try managedContext.save()
    } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }
    return friend
}

/**
 Saves a pending request to the local storage
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - name: the name of the pending request to be saved
 
 - version:
 1.0
 */
func savePendingFriendRequest(name: String) -> NSManagedObject{
    let entity =  NSEntityDescription.entityForName("PendingFriend",
                                                    inManagedObjectContext:managedContext)
    
    let friend = NSManagedObject(entity: entity!,
                                 insertIntoManagedObjectContext: managedContext)
    
    friend.setValue(name, forKey: "username")
    
    do {
        try managedContext.save()
    } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }
    return friend
}

// MARK: - Updates

/**
 Updates the local storage with the names of all pending requests for the signed in user
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - listOfNames: an array of names that represents the pending requests list
 
 - version:
 1.0
 */
func updatePendingRequests(listOfNames: [String]){
    deleteAllPendingRequests()
    var tempName: String!
    for friend in listOfNames{
        tempName = friend
        savePendingFriendRequest(tempName)
    }
}

/**
 Updates the local storage with the names of all friends for the signed in user
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - listOfNames: an array of names that represents the friends list
 
 - version:
 1.0
 */
func updateFriendsList(listOfNames: [String]){
    deleteAllFriends()
    var tempName: String!
    for friend in listOfNames{
        tempName = friend
        saveFriend(tempName)
    }
}

// MARK: - Messages

/**
 Saves a list of messages
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
 - list: JSON that contains an array of messages
 
 - version:
 1.0
 This function will call deleteMessagesFromDatabase. This function receives a string created by this function. The string will contain the message IDs to delete from the database
 */
func saveJSONMessages(list: JSON){
    let messages = list.arrayValue
    var stringOfIDs = ""
    for message in messages{
        let sender = message["sender"].description
        let text = message["text"].description
        let id = message["id"].int
        let isLocation = message["isLocation"].boolValue
        saveMessage(sender, text: text, messageID: id!, outgoing: false, location: isLocation)
        stringOfIDs += message["id"].description + ","
    }
    let truncated = String(stringOfIDs.characters.dropLast())
    deleteMessagesFromDatabase(truncated)
}

/**
 Saves a message to the managedObjectContext
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - senderUsername: the username of who is sending the message
    - text: the text of the message
    - messageID: the id of the message
        - outgoing: bool for whether or not the message is outgoing
 - location: bool for whether or not the message is a location
 
 - version:
 1.0
 */
func saveMessage(senderUsername: String, text: String, messageID: Int, outgoing: Bool, location: Bool){
    let entity =  NSEntityDescription.entityForName("Message",
                                                    inManagedObjectContext:managedContext)
    
    let message = NSManagedObject(entity: entity!,
                                  insertIntoManagedObjectContext: managedContext)
    
    message.setValue(senderUsername, forKey: "senderUsername")
    message.setValue(text, forKey: "text")
    message.setValue(messageID, forKey: "messageID")
    message.setValue(outgoing, forKey: "outgoing")
    message.setValue(location, forKey: "location")
    
    do {
        try managedContext.save()
    } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }
}
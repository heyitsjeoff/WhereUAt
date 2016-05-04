//
//  CoreDataFunctions.swift
//  Where U At
//
//  Created by Christopher Villanueva on 4/25/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//
import CoreData
import SwiftyJSON

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
    //2
    let entity =  NSEntityDescription.entityForName("Friend",
                                                    inManagedObjectContext:managedContext)
    
    let friend = NSManagedObject(entity: entity!,
                                 insertIntoManagedObjectContext: managedContext)
    
    //3
    friend.setValue(name, forKey: "username")
    
    //4
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
    //2
    let entity =  NSEntityDescription.entityForName("PendingFriend",
                                                    inManagedObjectContext:managedContext)
    
    let friend = NSManagedObject(entity: entity!,
                                 insertIntoManagedObjectContext: managedContext)
    
    //3
    friend.setValue(name, forKey: "username")
    
    //4
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

func saveJSONMessages(list: JSON){
    let messages = list.arrayValue
    var stringOfIDs = ""
    for message in messages{
        
        //senderUsername: String, text: String, messageID: Int, outgoing: Bool, location: Bool
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

func saveMessage(senderUsername: String, text: String, messageID: Int, outgoing: Bool, location: Bool){
    let entity =  NSEntityDescription.entityForName("Message",
                                                    inManagedObjectContext:managedContext)
    
    let message = NSManagedObject(entity: entity!,
                                  insertIntoManagedObjectContext: managedContext)
    
    //3
    message.setValue(senderUsername, forKey: "senderUsername")
    message.setValue(text, forKey: "text")
    message.setValue(messageID, forKey: "messageID")
    message.setValue(outgoing, forKey: "outgoing")
    message.setValue(location, forKey: "location")
    
    //4
    do {
        try managedContext.save()
        //5
        //messages.append(message)
    } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }
}
//
//  Thread.swift
//  Where U At
//
//  Created by Christopher Villanueva on 4/20/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData

/**
 A thread is used to represent a collection of messages. These messages are between a user
 and the user logged in to the device
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */
class Thread{
    
    var username: String? /*username of the thread participant*/
    var managedContext: NSManagedObjectContext? /*managed context so data can be added*/
    var messages = [NSManagedObject]() /*array of NSManagedObjects for messages*/
    var lastMessage: NSManagedObject? /*last message in array*/
    
    /**
     Constructor for the thread of username
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - username: - the username of the thread participant
     
     - version:
     1.0
     
     Sets the username for the thread and the managed context. Calls loadMessages passing
     in the username as the parameter
     */
    init(username: String){
        self.username = username /*sets username upon initialization*/
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate /*gets the delegate*/
        managedContext = appDelegate.managedObjectContext /*sets the managed context*/
        loadMessages(username) /*loads messages into array for username*/
        //lastMessage = messages.last /*sets lastMessage*/
        setLastMessage()
    }
    
    /**
     loads messages for username into the messages array of the Thread
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     
     - parameters:
        - username the username of the thread participant
    */
    func loadMessages(username: String){
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = NSPredicate(format: "senderUsername == %@", username)

        do {
            let results =
                try managedContext!.executeFetchRequest(fetchRequest)
            messages = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func setLastMessage(){
        let messageFetchRequest = NSFetchRequest(entityName: "Message")
        let locationPredicate = NSPredicate(format: "location == NO")
        messageFetchRequest.predicate = locationPredicate
        do {
            let results =
                try managedContext!.executeFetchRequest(messageFetchRequest)
            let messages = results as! [NSManagedObject]
            lastMessage = messages.last
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    /**
     returns the array of messages in the thread
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     an array of NSManagedObjects of entity type Message
     
     - version:
     1.0
     */
    func getMessagesArray() -> [NSManagedObject]{
        return messages
    }
}

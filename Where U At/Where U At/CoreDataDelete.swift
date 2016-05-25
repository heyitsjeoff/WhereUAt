//
//  CoreDataDelete.swift
//  Where U At
//
//  Created by Christopher Villanueva on 4/29/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

/**
 Consists of Core Data functions for deleting
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */

import CoreData

// MARK: - Friends

/**
 Deletes all friends from the local storage
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - version:
 1.0
 
 This is called during the update of the storage. The storage is purged of all friends to ensure there is
 no duplicate during update
 */
func deleteAllFriends(){
    
    //1
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "Friend")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try managedContext.executeRequest(deleteRequest)
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save \(error), \(error.userInfo)")
    }
}

/**
 Deletes all messages from the local storage
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - version:
 1.0
 
 This is called during the update of the storage. The storage is purged of all friends to ensure there is
 no duplicate during update
 */
func deleteAllMessages(){
    
    //1
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "Message")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try managedContext.executeRequest(deleteRequest)
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save \(error), \(error.userInfo)")
    }
}

/**
 Deletes all messages from the local storage
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - version:
 1.0
 
 This is called during the update of the storage. The storage is purged of all friends to ensure there is
 no duplicate during update
 */
func deleteAllMessagesFrom(username: String){
    
    //1
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let messageFetchRequest = NSFetchRequest(entityName: "Message")
    let senderPredicate = NSPredicate(format: "senderUsername == %@", username)
    messageFetchRequest.predicate = senderPredicate
    
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: messageFetchRequest)
    
    do {
        try managedContext.executeRequest(deleteRequest)
        try managedContext.save()
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
}

/**
 Deletes all pending requests from the local storage
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - version:
 1.0
 
 This is called during the update of the storage. The storage is purged of all pending requests to ensure there is
 no duplicate during update
 */
func deleteAllPendingRequests(){
    
    //1
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "PendingFriend")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try managedContext.executeRequest(deleteRequest)
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save \(error), \(error.userInfo)")
    }
}

/**
 Deletes all pending requests from the local storage
 
 - Author:
 Jeoff Villanueva
 
 - returns:
 void
 
 - parameters:
    - name: the username of the pending request to be deleted
 
 - version:
 1.0
 
 This is called during the update of the storage. The storage is purged of all pending requests to ensure there is
 no duplicate during update
 */
func deletePendingRequest(name: String){
    //1
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "PendingFriend")
    
    fetchRequest.predicate = NSPredicate(format: "username == %@", name)
    
    do {
        let results =
            try managedContext.executeFetchRequest(fetchRequest)
        let friendFound = results as! [NSManagedObject]
        let friend = friendFound[0]
        managedContext.deleteObject(friend)
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
    
    //4
    do {
        try managedContext.save()
    } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }
}
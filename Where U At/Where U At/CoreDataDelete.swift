//
//  CoreDataDelete.swift
//  Where U At
//
//  Created by Christopher Villanueva on 4/29/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

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
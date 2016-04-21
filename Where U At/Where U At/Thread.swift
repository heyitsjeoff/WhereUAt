//
//  Thread.swift
//  Where U At
//
//  Created by Christopher Villanueva on 4/20/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData

class Thread{
    
    var username: String?
    var managedContext: NSManagedObjectContext?
    var messages = [NSManagedObject]()
    var lastMessage: NSManagedObject?
    
    init(username: String){
        self.username = username
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        //print("loading messages for " + username)
        loadMessages(username)
        //print("messages done loading, count: " + String(messages.count))
        lastMessage = messages.last
        //print("last message: " + (lastMessage!.valueForKey("text") as? String)!)
    }
    
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
    
    func getMessagesArray() -> [NSManagedObject]{
        return messages
    }
}

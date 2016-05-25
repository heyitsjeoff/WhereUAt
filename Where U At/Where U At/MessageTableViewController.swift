//
//  MessageTableViewController.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData

/**
 The view controller for the MessageTableView
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 
 Will display all message threads that are on the device and access to a menu or the ability to compose a message
 */
class MessageTableViewController: UITableViewController {
    
    // MARK: - Properties
    var threads = [Thread]()
    var managedContext: NSManagedObjectContext?

    // MARK: - View Loading

    /**
     Called after the controller's view is loaded into memory. Calls loadThreads
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        loadThreads()
    }
    
    /**
     Called after the controller's view is loaded into memory. Calls loadThreads
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        animated: If true, the view is being added to the window using an animation
     
     - version:
     1.0
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        downloadAll()
        loadThreads()
    }
    
    // MARK: - Button actions
    
    /**
     Function to call when the menu button is pressed. Presents an action sheet of options for the menu
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - sender: the button that was pressed to call the function
     
     - version:
     1.0
     */
    @IBAction func menuButtonPressed(sender: AnyObject) {
        //create action sheet for menu
        let actionSheet = UIAlertController(title: nil, message: "Menu", preferredStyle: .ActionSheet)
        
        //friend option that uses the showFriends segue
        let friendsAction = UIAlertAction(title: "Friends", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("showFriends", sender: sender)
        })
        
        //credits option that uses the showCredits segue
        let creditsAction = UIAlertAction(title: "Credits", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("showCredits", sender: sender)
        })
        
        //signOut option that uses the signOut segue
        let signOutAction = UIAlertAction(title: "Sign Out", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("signOut", sender: sender)
        })
        
        //cancel option
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        //add actions to sheet
        actionSheet.addAction(friendsAction)
        actionSheet.addAction(creditsAction)
        actionSheet.addAction(signOutAction)
        actionSheet.addAction(cancelAction)
        
        //show action sheet
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: Functions
    
    /**
     loads all message threads to the message table view
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     */
    func loadThreads(){
        print("starting to load threads")
        //specify message as the entity for the fetch
        let messageFetchRequest = NSFetchRequest(entityName: "Message")
        do {
            //remove all threads before loading
            threads.removeAll()
            //results is the data from the fetch
            let results = try managedContext!.executeFetchRequest(messageFetchRequest)
            //messages will be an array representation of results
            let messages = results as! [NSManagedObject]
            
            //to determine what threads there will be, all messages will be traversed and the username of each
            //message will be looked at. if the username is not in listOfSenders, append the name and create
            //the thread for that user, otherwise go to the next message
            var listOfSenders = [String]()
            print("about to start for loop")
            for message in messages{
                let name = message.valueForKey("senderUsername") as? String
                if(!listOfSenders.contains(name!)){
                    listOfSenders.append(name!)
                    let thread = Thread(username: name!)
                    threads.append(thread)
                }
            }
            print("done with for loop")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        //reload the table view
        self.tableView.reloadData()
        print("done loading threads")
    }
    
    /**
     Goes back to the login view and delete all local app storage
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     
     Called within menuButtonPressed
     */
    func signOut(){
        //set entity to fetch as login
        let fetchRequest = NSFetchRequest(entityName: "Login")
        
        //create a delete request with fetchRequest
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext!.executeRequest(deleteRequest)
            try managedContext!.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        setUsername("") //set the instance of username to blank
        deleteAllFriends() //delete all friends stored in local storage
        deleteAllMessages() //delete all messages stored in local storage
        deleteAllPendingRequests() //delete all pending request stored in local storage
    }

    // MARK: - Table view data source functions

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
            forIndexPath: indexPath) as! MessageTableViewCell
        
        let thread = threads[indexPath.row]
        print("inside tableView loading for index" + String(indexPath.row))
        //let message = thread.lastMessage
        print("thread last message for " + thread.username + " is " + thread.getLastMessage())
//        cell.nameLabel.text = message!.valueForKey("senderUsername") as? String
//        print("cell label is " + cell.nameLabel.text!)
        cell.nameLabel.text = thread.username
        //image cell.userImageView.image = message.photo
        //cell.messageLabel.text = message!.valueForKey("text") as? String
        cell.messageLabel.text = thread.getLastMessage()
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let thread = threads[indexPath.row]
            deleteAllMessagesFrom(thread.username)
            threads.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        downloadAll()
        if(segue.identifier == "ShowMessage"){
            if let userMessageViewController = segue.destinationViewController as? UserMessageViewController{
                if let selectedMessageCell = sender as? MessageTableViewCell{
                    let indexPath = tableView.indexPathForCell(selectedMessageCell)
                    let selectedThread = threads[indexPath!.row]
                    userMessageViewController.username = selectedThread.username
                    userMessageViewController.title = selectedThread.username
                }
            }
        }
        else if(segue.identifier == "showFriends"){
            segue.destinationViewController as? FriendTableViewController
        }
        else if(segue.identifier == "showCredits"){
            segue.destinationViewController as? CreditsViewController
        }
        else if(segue.identifier == "signOut"){
            signOut()
            segue.destinationViewController as? SignInViewController
        }
    }
    

}

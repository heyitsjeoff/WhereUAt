//
//  MessageTableViewController.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData

class MessageTableViewController: UITableViewController {
    // MARK: Properties
    
    var threads = [Thread]()
    var managedContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        loadMessages()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let messageFetchRequest = NSFetchRequest(entityName: "Message")
        threads.removeAll()
        do {
            let results =
                try managedContext!.executeFetchRequest(messageFetchRequest)
            let messages = results as! [NSManagedObject]
            var listOfSenders = [String]()
            for message in messages{
                let name = message.valueForKey("senderUsername") as? String
                if(!listOfSenders.contains(name!)){
                    listOfSenders.append(name!)
                    let thread = Thread(username: name!)
                    threads.append(thread)
                }
//                let name = friend.valueForKey("username") as? String
//                let thread = Thread(username: name!)
//                threads.append(thread)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        // 1
        let actionSheet = UIAlertController(title: nil, message: "Menu", preferredStyle: .ActionSheet)
        
        // 2
        let friendsAction = UIAlertAction(title: "Friends", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("showFriends", sender: sender)
        })
        
//        let settingsAction = UIAlertAction(title: "Settings", style: .Default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            
//        })
        
        let creditsAction = UIAlertAction(title: "Credits", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("showCredits", sender: sender)
        })
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("signOut", sender: sender)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        actionSheet.addAction(friendsAction)
        //actionSheet.addAction(settingsAction)
        actionSheet.addAction(creditsAction)
        actionSheet.addAction(signOutAction)
        actionSheet.addAction(cancelAction)
        
        // 5
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    
    func loadMessages(){
//        saveMessage("molly", text: "hey, hows it going?", messageID: 3, outgoing: false, location: false)
//        saveMessage("zipper", text: "food!", messageID: 4, outgoing: false, location: false)
//        saveMessage("molly", text: "jk i dont care. wheres oscar?", messageID: 5, outgoing: false, location: false)
//        saveMessage("molly", text: "oscar is home", messageID: 6, outgoing: true, location: false)
    }
    
    func saveMessage(senderUsername: String, text: String, messageID: Int, outgoing: Bool, location: Bool){
        let entity =  NSEntityDescription.entityForName("Message",
                                                        inManagedObjectContext:managedContext!)
        
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
            try managedContext!.save()
            //5
            //messages.append(message)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func signOut(){
        print("Sign out pressed")
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Login")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.executeRequest(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        setUsername("")
    }

    // MARK: - Table view data source

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
        let message = thread.lastMessage
        cell.nameLabel.text = message!.valueForKey("senderUsername") as? String
        //image cell.userImageView.image = message.photo
        cell.messageLabel.text = message!.valueForKey("text") as? String

        return cell
    }
    
    // MARK: Segue
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        //let navVc = segue.destinationViewController as! UINavigationController // 1
        //let messageVc = navVc.viewControllers.first as! UserMessageViewController // 2
        if let destination = segue.destinationViewController as? UserMessageViewController{
            if let messageIndex = tableView.indexPathForSelectedRow?.row{
                destination.senderId = "55"
                destination.senderDisplayName = messages[messageIndex]?.senderUsername
            }
        }
    }
    */
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            threads.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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

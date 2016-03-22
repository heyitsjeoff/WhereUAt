//
//  MessageTableViewController.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {
    // MARK: Properties
    
    var messages = [Message?]()
    
    /*
    This value is either passed by `MealTableViewController` in 
        `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal.
    */
    var friend: Friend?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessages()
    }
    
    func loadMessages(){
        let message1 = Message(senderUsername: "Jeoff", text: "Hello world", messageID: 1, timeSent: "13:34")
        let message2 = Message(senderUsername: "Holly", text: "Molly is so adorable", messageID: 2, timeSent: "13:45")
        let message3 = Message(senderUsername: "Oscar", text: "I am cuter than Molly", messageID: 3, timeSent: "13:47")
        messages += [message1, message2, message3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
            forIndexPath: indexPath) as! MessageTableViewCell
        
        let message = messages[indexPath.row]

        cell.nameLabel.text = message?.senderUsername
        //image cell.userImageView.image = message.photo
        cell.messageLabel.text = message?.text

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
            messages.removeAtIndex(indexPath.row)
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
        if segue.identifier == "ShowMessage"{
            if let userMessageViewController = segue.destinationViewController as? UserMessageViewController{
                if let selectedMessageCell = sender as? MessageTableViewCell{
                    let indexPath = tableView.indexPathForCell(selectedMessageCell)
                    let selectedMessage = messages[indexPath!.row]
                    userMessageViewController.username = selectedMessage?.senderUsername
                    userMessageViewController.title = selectedMessage?.senderUsername
                }
            }
        }
    }
    

}

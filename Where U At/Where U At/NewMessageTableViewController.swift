//
//  FriendTableViewController.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData

class NewMessageTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var friends = [NSManagedObject]()
    
    // MARK: - View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     Notifies the view controller that its view is about to be added to a view hierarchy and
     loads an instance of friends to the array
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - animated: If true, the view is being added to the window using an animation
     
     - version:
     1.0
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Friend")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            friends = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Required table view functions
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FriendTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                                                               forIndexPath: indexPath) as! FriendTableViewCell
        
        let friend = friends[indexPath.row]
            
        cell.newMessageFriendUsername.text = friend.valueForKey("username") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends.count
        
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showNewMessage"){
            if let userMessageViewController = segue.destinationViewController as? UserMessageViewController{
                if let selectedFriend = sender as? FriendTableViewCell{
                    userMessageViewController.username = selectedFriend.friendUsername.text
                    userMessageViewController.title = selectedFriend.friendUsername.text
                }
            }
        }
     }
    
    
}

//
//  FriendTableViewController.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData

/**
 The view controller for the FriendTableView
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 
 Will display all friends and pending friend requests, as well as an option to add a friend
 */
class FriendTableViewController: UITableViewController {
    
    // MARK: - Properties
    var friends = [NSManagedObject]()
    var pendingRequests = [NSManagedObject]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext?
    
    // MARK: - View Loading
    
    /**
     Called after the controller's view is loaded into memory.
     Checks for pending friend requests and gets an updated friends list
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.managedObjectContext
        getFriendsList(self)
        getPendingRequests(self)
    }
    
    /**
     Notifies the view controller that its view is about to be added to a view hierarchy.
     Checks the local storage and updates the view with the friends list
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - animated: If true, the view is being added to the window using an animation.
     
     - version:
     1.0
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadFriendIntoControllerArray()
        loadPendingRequestsIntoControllerArray()
    }
    
    // MARK: - Buttons
    
    /**
     Button action to send a friend request
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - sender: the UIBarButtonItem that is pressed
     
     - version:
     1.0
     
     After the button is pressed, an alert will be presented allowing the user to 
     enter in a username to send a friend request to
     */
    @IBAction func sendFriendRequest(sender: UIBarButtonItem) {
        //create an alert
        let alert = UIAlertController(title: "Add a friend",
            message: "Enter your friend's username",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        //add action
        let add = UIAlertAction(title: "Add",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                print(textField!.text!)
                sendRequest(textField!.text!, theView: self)
        })
        
        //text field
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        //add actions to alert
        alert.addAction(cancelAction)
        alert.addAction(add)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    /**
     Checks the local storage for friends and loads them into the controller's array
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     */
    func loadFriendIntoControllerArray(){
        //set up the fetch for Friend
        let fetchRequest = NSFetchRequest(entityName: "Friend")
        do {
            let results =
                try managedContext!.executeFetchRequest(fetchRequest)
            friends = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    /**
     Checks the local storage for pending requests and loads them into the controller's array
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     */
    func loadPendingRequestsIntoControllerArray(){
        //set up the fetch for PendingFriend
        let fetchRequestPending = NSFetchRequest(entityName: "PendingFriend")
        do {
            let results =
                try managedContext!.executeFetchRequest(fetchRequestPending)
            pendingRequests = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Alert functions
    
    /**
     Presents an alert for a user to respond to a friend request. An accept or decline will be sent
     if the user does not cancel.
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - username: the username of the user being responded to
     
     - version:
     1.0
     
     This function is called when a FriendsTableViewCell is selected and is a pending requeset
     */
    func respondToRequest(username: String){
        let alert = UIAlertController(title: username,
                                      message: "How would you like to respond to \(username)'s request?",
                                      preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Sure",
                                      style: .Default,
                                      handler: { (action:UIAlertAction) -> Void in
                                        sendResponseToRequest(username, theResponse: "true", theView: self)
                                        //self.tableView.reloadData()
        })
        
        let noAction = UIAlertAction(title: "Nope",
                                     style: .Default,
                                     handler: { (action:UIAlertAction) -> Void in
                                        sendResponseToRequest(username, theResponse: "false", theView: self)
                                        //self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    /**
     Presents an alert based on the success status of sending a friend request
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - success: the status of whether or not the friend request was sent
     
     - version:
     1.0
     */
    func alertSendRequest(success: String){
        if(success == "true"){
            let alert = UIAlertController(title: "Where U At",
                                          message: "Your friend request has been sent!",
                                          preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Yay",
                                         style: .Default) { (action: UIAlertAction) -> Void in
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                                  animated: true,
                                  completion: nil)
        }
        else if(success == "false"){
            let alert = UIAlertController(title: "Where U At",
                                          message: "Your friend request was not sent, please try again",
                                          preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Cry",
                                         style: .Default) { (action: UIAlertAction) -> Void in
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                                  animated: true,
                                  completion: nil)
        }
    }
    
    /**
     Presents an alert based on the success status of responding to a friend request
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - success: the status of whether or not the friend request response was sent
        - username: the username of the user being responded to
        - theResponse: the response to the friend request
     
     - version:
     1.0
     */
    func alertRespondRequest(success: String){
        if(success == "true"){
            let alert = UIAlertController(title: "Where U At",
                                          message: "Your friend request response has been sent!",
                                          preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Yay",
                                         style: .Default) { (action: UIAlertAction) -> Void in
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                                  animated: true,
                                  completion: nil)
        }
        else if(success == "false"){
            let alert = UIAlertController(title: "Where U At",
                                          message: "Your friend request response was not sent, please try again",
                                          preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Cry",
                                         style: .Default) { (action: UIAlertAction) -> Void in
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                                  animated: true,
                                  completion: nil)
        }
    }
    
    // MARK: - Updating
    
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
    func updateFriendsListArray(listOfNames: [String]){
        updateFriendsList(listOfNames)
        loadFriendIntoControllerArray()
    }
    
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
    func updatePendingRequestsArray(listOfNames: [String]){
        updatePendingRequests(listOfNames)
        loadPendingRequestsIntoControllerArray()
    }
    
    
    
    // MARK: - Required table view functions
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FriendTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                                                               forIndexPath: indexPath) as! FriendTableViewCell
        
        if(indexPath.section == 0){
            let friend = friends[indexPath.row]
            
            cell.friendUsername.text = friend.valueForKey("username") as? String
        }
        else{
            let friend = pendingRequests[indexPath.row]
            
            cell.friendUsername.text = friend.valueForKey("username") as? String
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0){
            
        }
        else{
            let friend = pendingRequests[indexPath.row]
            let username = friend.valueForKey("username") as! String
            respondToRequest(username)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return friends.count
        }
        else{
            return pendingRequests.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Friends"
        }
        else{
            return "Pending Friend Requests"
        }
    }
    
}

//
//  FriendTableViewController.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData

class FriendTableViewController: UITableViewController {
    
    //MARK: - Vars
    
    var friends = [NSManagedObject]()
    var pendingRequests = [NSManagedObject]()
    
    //MARK: - Actions
    
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
        let alert = UIAlertController(title: "Add a friend",
            message: "Enter your friend's username",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        let add = UIAlertAction(title: "Add",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                print(textField!.text!)
                sendRequest(textField!.text!, theView: self)
                //self.tableView.reloadData()
        })
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(add)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    
    func getPendingFriendRequests(){
        getPendingRequests(self)
    }
    
    func getFriends(){
        getFriendsList(self)
    }
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleFriends()
        getFriends()
        getPendingFriendRequests()
    }
    
    /**
     checks the local storage and updates the view with the friends list
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - animated: boolean for wheter or not to have animation
     
     - version:
     1.0
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Friend")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            friends = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        let fetchRequestPending = NSFetchRequest(entityName: "PendingFriend")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequestPending)
            pendingRequests = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func loadSampleFriends(){
        //deletePending("Zipper")
//        saveFriend("molly")
//        saveFriend("moscar")
//        savePendingFriend("zipper")
//        savePendingFriend("anchovie")
    }
    
    // MARK: - Core Data
    
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
    func saveFriend(name: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
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
            //5
            friends.append(friend)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Deletes
    
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
    func deleteFriends(){
        
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
    func deletePendingRequests(){
        
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
    
    // MARK: - Update lists
    
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
        print("updating friends list")
        deleteFriends()
        var tempName: String!
        for friend in listOfNames{
            tempName = friend
            saveFriend(tempName)
        }
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
    func updatePendingRequests(listOfNames: [String]){
        deletePendingRequests()
        var tempName: String!
        for friend in listOfNames{
            tempName = friend
            savePendingFriend(tempName)
        }
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
    func savePendingFriend(name: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
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
            //5
            pendingRequests.append(friend)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deletePending(name: String){
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
            print(friend)
            //let indexOfFriend = friends.indexOf(friend)
            //print(indexOfFriend)
            managedContext.deleteObject(friend)
            //friends.removeAtIndex(indexOfFriend!)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //4
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    
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
    
    // MARK: - Alert Functions
    
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
    func alertRespondRequest(success: String, username: String, theResponse: String){
        if(success == "true"){
            let alert = UIAlertController(title: "Where U At",
                                          message: "Your friend request response has been sent!",
                                          preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Yay",
                                         style: .Default) { (action: UIAlertAction) -> Void in
//                                            if(theResponse == "true"){
//                                                //self.deletePending(username)
//                                                //self.getFriends()
//                                                //self.getPendingFriendRequests()
//                                            }
//                                            else if(theResponse == "false"){
//                                                self.deletePending(username)
//                                                self.getFriends()
//                                                self.getPendingFriendRequests()
//                                            }
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
    
    // MARK: - Section Functions
    
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

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
    
    var friends = [NSManagedObject]()
    var pendingRequests = [NSManagedObject]()
    
    func newMessage(username: String){
        
    }
    
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
                //self.newMessage(textField!.text!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleFriends()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Friend")
        //fetchRequest.predicate = NSPredicate(format: "isPending == @YES")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            friends = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func loadSampleFriends(){
        //saveFriend("Holly")
        //saveFriend("Moscar")
        //savePendingFriend("Zipper")
    }
    
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
        friend.setValue(false, forKey: "isPending")
        
        //4
        do {
            try managedContext.save()
            //5
            friends.append(friend)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func savePendingFriend(name: String) {
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
        friend.setValue(true, forKey: "isPending")
        
        //4
        do {
            try managedContext.save()
            //5
            pendingRequests.append(friend)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Methods
    
    /**
    Presents an alert based on the success status of a sending a friend request. A successful
    sent friend request will let the user know of the success, and the same goes for an
    unsuccessful one
    
    @param success the success status of the send request attempt
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
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FriendTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
            forIndexPath: indexPath) as! FriendTableViewCell
        let friend = friends[indexPath.row]
        
        cell.friendUsername.text = friend.valueForKey("username") as? String
        
        return cell
    }
    
    // MARK: - Section 
    
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
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

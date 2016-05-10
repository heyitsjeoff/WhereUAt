//
//  UserMessageViewController.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/5/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import CoreData
import JSQMessagesViewController
import CoreLocation
import SwiftyJSON

/**
 Implements JSQMessagesViewController to display messages between the user and
 thread participant. The user can send his/her current location, see messages
 the other participant has sent, and the other users location if it has been
 sent.
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */
class UserMessageViewController: JSQMessagesViewController, CLLocationManagerDelegate {
    var username: String! //username of the thread participant
    var managedContext: NSManagedObjectContext? //managed object context for core data
    var thread: Thread? //the thread consisting of messages
    var myLocation: CLLocation? //location of the signed in user
    var myLongitude: String? //longitude of the signed in user
    var myLatitude: String? //latitude of the signed in user
    var userLongitude: String! //longitude of the thread participant
    var userLatitude: String! //latitude of the thread participant
    var messages = [NSManagedObject]() //array of NSManagedObjects with the message entity
    let locationManager = CLLocationManager() //CLLocationManager to use cllocation
    var broadcastInterval: Double! //double for representing broadcast interval in seconds
    var timer = NSTimer() //NSTimer for broadcasting interval
    var getTimer = NSTimer() //NSTimer for doing gets on the server
    let getInterval = 5.0 //a double value to use within startGettingPendingMessages
    var isBroadcasting = false //boolean representation for broadcasting state
    
    /**
     Grabs the AppDelegate and sets the managedObjectContext. Sets the sender display names. Initializes some JSQ settings for the view. Intializes the location manager. Initializes the message thread and loads them into an array. Finds the last location of the user and starts the polling for new data.
     
     - Author:
     Jeoff Villanueva
     
     - returns:
    void
     
     - version:
     1.0
     
     Called when the view loads for the first time
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        
        //MARK: - JSQ initialization
        if let username = username{
            self.senderDisplayName = username
        }else{
            self.senderDisplayName = "Person"
        }
        self.senderId = "1234"
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero; //sets the avatar image size for outgoing messages to nothing
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero; //sets the avatar image size for incoming messages to nothing
        self.inputToolbar!.contentView?.leftBarButtonItem = JSQMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem.init(image: UIImage.jsq_defaultTypingIndicatorImage(), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UserMessageViewController.showMap(_:))), animated: true)
        
        //MARK: - Location Manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //MARK: - Loads messages
        thread = Thread(username: username!)
        messages = thread!.getMessagesArray()
        findLastLocationOfUser()
        startGettingPendingMessages()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        thread = Thread(username: username!)
        messages = thread!.getMessagesArray()
    }
    
    
    func getPendingMessages(){
        getMessages(self)
    }
    
    /**
     Saves a list of messages
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - list: JSON that contains an array of messages
     
     - version:
     1.0
     This function will call deleteMessagesFromDatabase. This function receives a string created by this function. The string will contain the message IDs to delete from the database
     */
    func saveJSONMessages(list: JSON){
        let messages = list.arrayValue //gets the array value of list and assigns it to messages
        var stringOfIDs = "" //create an empty string to begin concat
        for message in messages{
            let sender = message["sender"].description //description used to get string value of sender
            let text = message["text"].description //description used to get string value of text
            let id = message["id"].int //int used to get int value of id
            let isLocation = message["isLocation"].boolValue //boolValue used to get bool value of isLocatoin
            saveMessage(sender, text: text, messageID: id!, outgoing: false, location: isLocation) //call save message with extracted data
            stringOfIDs += message["id"].description + "," //concat message id after saveMessage called to prepare for deletion
        }
        let truncated = String(stringOfIDs.characters.dropLast())//used to remove a trailing comma
        if(stringOfIDs != ""){
            deleteMessagesFromDatabase(truncated)
        }
    }
    
    /**
     Performs a segue to a MapKitView
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - sender: the UIBarButtonItem that was pressed
     
     - version:
     1.0
     */
    @IBAction func showMap(sender: UIBarButtonItem) {
        self.locationManager.requestWhenInUseAuthorization()
        performSegueWithIdentifier("showMap", sender: sender)
    }
    
    /**
     Presents a UIAlert ActionSheet to send location or stop broadcasting
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - sender: the accessory button that was pressed
     
     - version:
     1.0
     */
    override func didPressAccessoryButton(sender: UIButton!) {
        //create an actionSheet for starting or stopping broadcast
        let actionSheet = UIAlertController(title: nil, message: "Actions", preferredStyle: .ActionSheet)
        var locationAction: UIAlertAction
        //if the user is broadcasting, give the option to stop. Otherwise give the option to broadcast
        if(isBroadcasting){
            locationAction = UIAlertAction(title: "Stop broadcasting", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.stopBroadcasting() //call stopBroadcasting
            })
        }
        else{
            locationAction = UIAlertAction(title: "Send location", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.requestLocationInterval() //call requestLocationInterval
            })
        }
        
        //cancelAction
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        //Add created actions to  actionSheet
        actionSheet.addAction(locationAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    /**
     Requests the user for the location interval for sending location
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     
     This function is called from locationAction within didPressAccessoryButton
     */
    func requestLocationInterval(){
        //request permission to use location
        self.locationManager.requestWhenInUseAuthorization()
        
        //create an alert for setting broadcast interval
        let alert = UIAlertController(title: "Send Location",
                                      message: "Send your location every _ seconds",
                                      preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        //create an action to allow the start of broadcasting
        let start = UIAlertAction(title: "Start",
                                style: .Default,
                                handler: { (action:UIAlertAction) -> Void in
                                    let textField = alert.textFields!.first
                                    self.setBroadcastInterval(textField!.text!)
                                    
        })
        
        //Add a text field for input to alert
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        //Add created actions to alert
        alert.addAction(cancelAction)
        alert.addAction(start)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Sets the broadcast interval for sending location and calls startBroadcasting
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - frequency: the frequency of broadcasting in seconds as a string
     
     - version:
     1.0
     */
    func setBroadcastInterval(frequency: String){
        broadcastInterval = Double(frequency)
        startBroadcasting()
    }
    
    /**
     Starts the timer for the broadcast interval. Fire action on interval is sendLocation. Sets isBroadcasting to true
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     
     Is called by setBroadcastInterval(frequency: String)
     */
    func startBroadcasting(){
        isBroadcasting = true
        let interval = broadcastInterval
        //start timer
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(self.sendLocation), userInfo: nil, repeats: true)
    }
    
    /**
     Start the timer to poll data
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     
     called by viewDidLoad
     */
    func startGettingPendingMessages(){
        //start getTimer
        getTimer = NSTimer.scheduledTimerWithTimeInterval(getInterval, target: self, selector: #selector(self.getPendingMessages), userInfo: nil, repeats: true)
    }
    
    /**
     Stops the timer for the broadcast interval. Sets isBroadcasting to false and broadcastInterval to nil
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     
     Is called by locationAction within didPressAccessoryButton
     */
    func stopBroadcasting(){
        broadcastInterval = nil;
        timer.invalidate() //stops timer
        isBroadcasting = false
    }
    
    /**
     Requests the location of the device
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     
     Starts a chain of functions to send location of device to server. A chain of functions is required because a CLLocation object can only be handled within locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
     */
    func sendLocation(){
        self.locationManager.requestLocation() //request device location
    }
    
    /**
     Function used to set myLocation, myLongitiude, and myLatitude. Sends the location as a message
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - location: CLLocation representation of device location
     
     - version:
     1.0
     
     Called by locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
     */
    func captureLocation(location: CLLocation){
        myLocation = location
        myLongitude = String(myLocation!.coordinate.longitude)
        myLatitude = String(myLocation!.coordinate.latitude)
        let coordinate = myLatitude! + "," + myLongitude! //sets up a string for sending location
        sendMessage(username, text: coordinate, location: true, theView: self)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations.last
        captureLocation(myLocation!)//called to set myLocation and continue chain to send location
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    /**
     Saves a message to the managedObjectContext
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - senderUsername: the username of who is sending the message
        - text: the text of the message
        - messageID: the id of the message
        - outgoing: bool for whether or not the message is outgoing
        - location: bool for whether or not the message is a location
     
     - version:
     1.0
     
     More details
     */
    func saveMessage(senderUsername: String, text: String, messageID: Int, outgoing: Bool, location: Bool){
        //set the entity
        let entity =  NSEntityDescription.entityForName("Message",
                                                        inManagedObjectContext:managedContext!)
        //create an NSManagedObject with entity
        let message = NSManagedObject(entity: entity!,
                                      insertIntoManagedObjectContext: managedContext)
        
        //sets the values for the message
        message.setValue(senderUsername, forKey: "senderUsername")
        message.setValue(text, forKey: "text")
        message.setValue(messageID, forKey: "messageID")
        message.setValue(outgoing, forKey: "outgoing")
        message.setValue(location, forKey: "location")
        
        //attempt to save managedContext
        do {
            try managedContext!.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        thread?.loadMessages(username) //load thread
        messages = thread!.getMessagesArray() //set messages
        self.finishSendingMessageAnimated(true) //append new message
    }
    
    /**
     Converts a message(NSManagedObject) to a JSQMessage and returns it
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - message: the message to be converted
     
     - version:
     1.0
     
     JSQMessageViewController displays JSQMessages only
     */
    func messageToJSQ(message: NSManagedObject) -> JSQMessage{
        let username = message.valueForKey("senderUsername") as? String
        let text = message.valueForKey("text") as? String
        let outgoing = message.valueForKey("outgoing") as? Bool
        var id: String?
        if(outgoing == true){
            id = self.senderId
        }
        else{
            id = "14" //some value to distinguish from self for JSQ
        }
        return JSQMessage(senderId: id, displayName: username, text: text);
    }
    
    // MARK: - Visual response
    
    func messageSent(senderUsername: String, text: String, messageID: Int, location: Bool){
        saveMessage(senderUsername, text: text, messageID: messageID, outgoing: true, location: location)
    }
    
    /**
     Finds the last location saved and sets userLatitude and userLongitude
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     */
    func findLastLocationOfUser(){
        let messageFetchRequest = NSFetchRequest(entityName: "Message")
        let locationPredicate = NSPredicate(format: "location == YES")
        let outgoingPredicate = NSPredicate(format: "outgoing == NO")
        messageFetchRequest.predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [locationPredicate, outgoingPredicate])
        do {
            let results =
                try managedContext!.executeFetchRequest(messageFetchRequest)
            let locations = results as! [NSManagedObject]
            if(locations.count != 0){
                let lastLocation = locations.last
                let coordinates = lastLocation!.valueForKey("text") as! String
                let locationArray = coordinates.characters.split{$0 == ","}.map(String.init)
                userLatitude = locationArray[0]
                userLongitude = locationArray[1]
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Buttons
    
    /**
     Function called when the Send button is pressed
     
     - Author:
     JSQ with modifications by Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - button: the UIButton pressed
        - withMessageText text: the message that was in the text field
        - senderId: the id of the sender
        - senderDisplayName: the name of the sender
        - date: the data the message was sent
     
     - version:
     1.0
     */
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        //let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text);
        sendMessage(username, text: text, location: false, theView: self)
        //self.finishSendingMessageAnimated(true);
    }
    
    
    // MARK: - Collection View Required Functions
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData!
    {
        let theMessage = self.messages[indexPath.item]
        return messageToJSQ(theMessage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let factory = JSQMessagesBubbleImageFactory();
        let theMessage = self.messages[indexPath.item]
        let message = messageToJSQ(theMessage)
        if(message.senderId == "1234" && theMessage.valueForKey("location") as! Bool != true){
            return factory.outgoingMessagesBubbleImageWithColor(UIColor.blueColor());
        }
        else{
            if(theMessage.valueForKey("location") as! Bool != true){
                return factory.incomingMessagesBubbleImageWithColor(UIColor.lightGrayColor());
            }
        }
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath);
        
        // This doesn't really do anything, but it's a good point for customization
        //let message = self.messages[indexPath.item];
        
        return cell;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil;
    }
    
    // MARK: - Navigation

    /**
     Gets the segue ready for transitioning to the map view
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - segue: The segue object containing information about the view controllers involved in the segue
        - sender: The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue
     
     - version:
     1.0
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMap"{
            findLastLocationOfUser()//called to make sure current instance of location is the most recent
            let theView = segue.destinationViewController as! MapKitViewController //set new controller as a MapKitViewController
            if(userLatitude != nil && userLongitude != nil){//check to see if a location exists in the controller instance
                theView.userLongitude = userLongitude //passes the userLongitiude to the controller
                theView.userLatitude = userLatitude //passes the userLatitude to the controller
                theView.username = username //passes the username to the controller
                theView.myLatitude = myLatitude //passes myLatitude to the controller
                theView.myLongitude = myLongitude //passes myLongitude to the controller
            }
        }

    }

}

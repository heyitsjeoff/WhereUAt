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
class UserMessageViewController: JSQMessagesViewController,CLLocationManagerDelegate {
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
    var isBroadcasting = false //boolean representation for broadcasting state
    
    
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
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        self.inputToolbar!.contentView?.leftBarButtonItem = JSQMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem.init(image: UIImage.jsq_defaultTypingIndicatorImage(), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UserMessageViewController.showMap(_:))), animated: true)
        
        //MARK: - Location Manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //MARK: - Loads messages
        thread = Thread(username: username!)
        messages = thread!.getMessagesArray()
        findLastLocationOfUser()
        startGetting()
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
     */
    func saveJSONMessages(list: JSON){
        let messages = list.arrayValue
        var stringOfIDs = ""
        for message in messages{
            let sender = message["sender"].description
            let text = message["text"].description
            let id = message["id"].int
            let isLocation = message["isLocation"].boolValue
            saveMessage(sender, text: text, messageID: id!, outgoing: false, location: isLocation)
            stringOfIDs += message["id"].description + ","
        }
        let truncated = String(stringOfIDs.characters.dropLast())
        if(stringOfIDs != ""){
            deleteMessagesFromDatabase(truncated)
        }
        //thread!.reload()
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        thread = Thread(username: username!)
        messages = thread!.getMessagesArray()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        // 1
        let actionSheet = UIAlertController(title: nil, message: "Actions", preferredStyle: .ActionSheet)
        var locationAction: UIAlertAction
        // 2
        if(isBroadcasting){
            locationAction = UIAlertAction(title: "Stop broadcasting", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.stopBroadcasting()
            })
        }
        else{
            locationAction = UIAlertAction(title: "Send location", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.requestLocationInterval()
            })
        }
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        // 4
        actionSheet.addAction(locationAction)
        actionSheet.addAction(cancelAction)
        
        // 5
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
        self.locationManager.requestWhenInUseAuthorization()
        let alert = UIAlertController(title: "Send Location",
                                      message: "Send your location every _ seconds",
                                      preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        let add = UIAlertAction(title: "Start",
                                style: .Default,
                                handler: { (action:UIAlertAction) -> Void in
                                    let textField = alert.textFields!.first
                                    self.setBroadcastInterval(textField!.text!)
                                    
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
    
    /**
     Sets the broadcast interval for sending location
     
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
        print("broadcast started")
        isBroadcasting = true
        let interval = broadcastInterval
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(self.sendLocation), userInfo: nil, repeats: true)
    }
    
    func startGetting(){
        getTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.getPendingMessages), userInfo: nil, repeats: true)
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
        print("broadcast stopped")
        broadcastInterval = nil;
        timer.invalidate()
        isBroadcasting = false
    }
    
    func sendLocation(){
        print("location will be sent")
        self.locationManager.requestLocation()
    }
    
    func captureLocation(location: CLLocation){
        myLocation = location
        myLongitude = String(myLocation!.coordinate.longitude)
        myLatitude = String(myLocation!.coordinate.latitude)
        let coordinate = myLatitude! + "," + myLongitude!
        sendMessage(username, text: coordinate, location: true, theView: self)
        print("sendMessage called with coordinates: ")
        print("latitude: " + String(myLatitude))
        print("longitude: " + String(myLongitude))
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations.last
        captureLocation(myLocation!)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
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
        thread?.loadMessages(username)
        messages = thread!.getMessagesArray()
        self.finishSendingMessageAnimated(true)
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
    
    
    // MARK: - Table View
    
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMap"{
            findLastLocationOfUser()
            let theView = segue.destinationViewController as! MapKitViewController
            if(userLatitude != nil && userLongitude != nil){
                print("lat:" + userLatitude)
                print("lon:" + userLongitude)
                theView.userLongitude = userLongitude
                theView.userLatitude = userLatitude
                theView.username = username
                theView.myLatitude = myLatitude
                theView.myLongitude = myLongitude
            }
        }

    }

}

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
    var username: String!
    var managedContext: NSManagedObjectContext?
    var thread: Thread?
    var myLocation: CLLocation?
    var myLongitude: String?
    var myLatitude: String?
    var messages = [NSManagedObject]()
    let locationManager = CLLocationManager()
    
    
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
        
        print("user message view controller will call getPendingMessages")
        getPendingMessages()
        
        //MARK: - Loads messages
        thread = Thread(username: username!)
        messages = thread!.getMessagesArray()
        
    }
    
    func getPendingMessages(){
        getMessages(self)
    }
    
    func saveJSONMessages(list: JSON){
        let messages = list.arrayValue
        var stringOfIDs = ""
        for message in messages{
            
            //senderUsername: String, text: String, messageID: Int, outgoing: Bool, location: Bool
            let sender = message["sender"].description
            let text = message["text"].description
            let id = message["id"].int
            let isLocation = message["isLocation"].boolValue
            saveMessage(sender, text: text, messageID: id!, outgoing: false, location: isLocation)
            stringOfIDs += message["id"].description + ","
        }
        let truncated = String(stringOfIDs.characters.dropLast())
        deleteMessagesFromDatabase(truncated)
    }
    
    @IBAction func showMap(sender: UIBarButtonItem) {
        print("rightbarbutton pressed")
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
        
        // 2
        let locationAction = UIAlertAction(title: "Send location", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sendLocation();
        })
        
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
    
    func sendLocation(){
        print("location sent")
        self.locationManager.requestLocation()
    }
    
    func captureLocation(location: CLLocation){
        myLocation = location
        myLongitude = String(myLocation!.coordinate.longitude)
        myLatitude = String(myLocation!.coordinate.latitude)
        let coordinate = myLongitude! + "," + myLatitude!
        sendMessage(username, text: coordinate, location: true, theView: self)
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
        self.finishSendingMessageAnimated(true)
    }
    
    //MARK: - Buttons
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text);
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
            return factory.incomingMessagesBubbleImageWithColor(UIColor.lightGrayColor());
        }
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
            segue.destinationViewController as? MapKitViewController
        }

    }

}

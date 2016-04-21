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

class UserMessageViewController: JSQMessagesViewController {
    var username: String?
    var managedContext: NSManagedObjectContext?
    var thread: Thread?
    var messages = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        if let username = username{
            self.senderDisplayName = username
        }else{
            self.senderDisplayName = "Person"
        }
        self.senderId = "1234"
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        self.inputToolbar!.contentView?.leftBarButtonItem = nil
        thread = Thread(username: username!)
        messages = thread!.getMessagesArray()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        thread = Thread(username: username!)
        messages = thread!.getMessagesArray()
    }
    
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
        if(message.senderId == "1234"){
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

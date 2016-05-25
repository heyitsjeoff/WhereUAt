//
//  CoreDataLoad.swift
//  Where U At
//
//  Created by Christopher Villanueva on 4/29/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

/**
 Consists of Core Data functions for loading
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 */

import CoreData

func downloadAll(){
    getFriendsList()
    getPendingRequests()
    getMessages()
}
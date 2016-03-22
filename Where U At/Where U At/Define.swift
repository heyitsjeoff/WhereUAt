//
//  Define.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/2/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import Foundation

/**
 static variables used for Where U At. Allows for quick changes without modifying code throughout
*/
class Variables{
    static let SERVER = "http://152.117.214.185:8080/"
    static let AUTHENTICATE = "http://152.117.214.185:8080/api/authenticate/"
    static let CREATE = "http://152.117.214.185:8080/api/create/"
    static let FAILED = 0
    static let SUCCESS = 1
    static let NOTCONNECTED = 2
    static let USERNAMETAKEN = 3
    
}
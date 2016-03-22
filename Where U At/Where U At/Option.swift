//
//  Option.swift
//  Where U At
//
//  Created by Christopher Villanueva on 3/21/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit

class Option{
    // MARK: Properties
    
    var name: String
    
    //var icon: UIImage
    
    // MARK: Initialization
    
    init?(name: String){
        self.name = name
        
        if(name.isEmpty){
            return nil
        }
    }
}

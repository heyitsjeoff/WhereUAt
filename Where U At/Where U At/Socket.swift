//
//  Socket.swift
//  Where U At
//
//  Created by Christopher Villanueva on 4/10/16.
//  Copyright © 2016 Jeoff Villanueva. All rights reserved.
//

import UIKit
import Starscream

let socket = WebSocket(url: NSURL(string: variables.WSSERVER)!)

func websocketDidConnect(ws: WebSocket) {
    print("websocket is connected")
}

func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
    if let e = error {
        print("websocket is disconnected: \(e.localizedDescription)")
    } else {
        print("websocket disconnected")
    }
}

func websocketDidReceiveMessage(ws: WebSocket, text: String) {
    print("Received text: \(text)")
}

func websocketDidReceiveData(ws: WebSocket, data: NSData) {
    print("Received data: \(data.length)")
}
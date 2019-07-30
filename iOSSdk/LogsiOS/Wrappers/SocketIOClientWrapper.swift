//
//  SocketIOClientWrapper.swift
//  TestingBonjour
//
//  Created by José Mota on 23/01/2019.
//  Copyright © 2019 José Mota. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOClientWrapper: NSObject {
    
    let hostname: String
    let port: Int
    var debug = false
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    private let deviceId = UIDevice.current.name.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "´", with: "").replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "’", with: "").replacingOccurrences(of: "ʀ", with: "R")
    
    init(hostname: String, port: Int) {
        self.hostname = hostname
        self.port = port
    }
    
    func start() {
        manager = SocketManager.init(socketURL: URL(string: "http://\(hostname):\(port)")!, config: [.log(debug), .forceWebsockets(true)])
        socket = manager?.defaultSocket
        socket?.connect()
        socket?.onAny({ [weak self] event in
            
            if event.event == "ping" || event.event == "pong" {
                return
            }
            
            NSLog("LogsiOS event: %@", event.event)
            switch event.event {
            case "connect":
                if let deviceId = self?.deviceId {
                    self?.socket?.emit("register", deviceId)
                }
                break
            default: break
            }
        })
    }
    
    func sendLog(message: String) {
        socket?.emit(deviceId, message)
    }
    
}

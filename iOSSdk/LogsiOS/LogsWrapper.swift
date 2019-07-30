//
//  LogsWrapper.swift
//  TestingBonjour
//
//  Created by José Mota on 23/01/2019.
//  Copyright © 2019 José Mota. All rights reserved.
//

import Foundation

public class LogsWrapper: NSObject {
    
    private static var sharedInstance: LogsWrapper = LogsWrapper()
    
    private let bonjourClient = Bonjour()
    private var socketClientWrappers: [SocketIOClientWrapper] = []
    public static var debug = false
    
    public static func start() {

        sharedInstance.bonjourClient.findService(Bonjour.Services.SocketIO, domain: Bonjour.LocalDomain) { service in
            
            if let hostname = service?.hostName, let port = service?.port {
                sharedInstance.initSocket(hostname: hostname, port: port)
            }
        }
    }
    
    
    private func initSocket(hostname: String, port: Int) {
        let socketWrapper = SocketIOClientWrapper.init(hostname: hostname, port: port)
        socketWrapper.debug = LogsWrapper.debug
        socketClientWrappers.append(socketWrapper)
        socketWrapper.start()
    }
    
    public static func sendLog(_ message: String) {
        
        sharedInstance.socketClientWrappers.forEach {
            $0.sendLog(message: message)
        }
    }
    
}

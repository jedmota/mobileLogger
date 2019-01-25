//
//  LogsWrapper.swift
//  TestingBonjour
//
//  Created by José Mota on 23/01/2019.
//  Copyright © 2019 José Mota. All rights reserved.
//

import Foundation

public class LogsWrapper: NSObject {
    
    public static var sharedInstance: LogsWrapper = LogsWrapper()
    
    let bonjourClient = Bonjour()
    var socketClientWrappers: [SocketIOClientWrapper] = []
    public var debug = false
    
    public func start() {

        bonjourClient.findService(Bonjour.Services.SocketIO, domain: Bonjour.LocalDomain) { [weak self] service in
            
            if let hostname = service?.hostName, let port = service?.port {
                
                self?.initSocket(hostname: hostname, port: port)
            }
        }
    }
    
    
    private func initSocket(hostname: String, port: Int) {
        let socketWrapper = SocketIOClientWrapper.init(hostname: hostname, port: port)
        socketWrapper.debug = debug
        socketClientWrappers.append(socketWrapper)
        socketWrapper.start()
    }
    
    public func sendLog(_ message: String) {
        
        socketClientWrappers.forEach {
            $0.sendLog(message: message)
        }
    }
    
}

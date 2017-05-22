//
//  WatchSessionDelegate.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/11/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import WatchConnectivity

public class WatchSessionManager: NSObject, WCSessionDelegate {
    
    public static let shared = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    
    var validSession: WCSession? {
        #if os(iOS)
            if let session = session, session.isPaired && session.isWatchAppInstalled {
                return session
            } else {
                return nil
            }
        #else
            return session
        #endif
    }
    
    public func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(error ?? "No Error")
    }
    
    #if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
    
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
    
    }
    #endif

    // Sender
    public func updateApplicationContext() {
        if let session = validSession {
            do {
                try session.updateApplicationContext(ContextManager.context)
            } catch let error {
                print(error)
            }
        }
    }
    
    // Receiver
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Recieved context!!")
        DispatchQueue.main.async() {
            ContextManager.context = applicationContext
        }
    }
}

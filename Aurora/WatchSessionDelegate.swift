//
//  WatchSessionDelegate.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/11/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import WatchConnectivity

class WatchSession: NSObject, WCSessionDelegate {
    static let shared = WatchSession()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}

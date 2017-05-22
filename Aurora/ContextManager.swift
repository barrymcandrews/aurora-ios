//
//  ContextManager.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/21/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

public class ContextManager: NSObject {
    
    static var context: [String: Any] {
        get {
           let context = [
                "hostname": Request.hostname!,
                "port": Request.port!,
                "requests": NSKeyedArchiver.archivedData(withRootObject: RequestContainer.shared.requests)
            ] as [String : Any]
            print(context)
            return context
        }
        
        set {
            if let hostname = newValue["hostname"] as? String {
                Request.hostname = hostname
            }
            
            if let port = newValue["port"] as? String {
                Request.port = port
            }
            
            if let requests = newValue["requests"] as? Data {
                RequestContainer.shared.requests = NSKeyedUnarchiver.unarchiveObject(with: requests) as! [Request]
            }
        }
    }
    
}

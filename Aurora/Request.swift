//
//  Request.swift
//  Aurora
//
//  Created by Barry McAndrews on 3/31/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import Alamofire

public struct PropertyKey {
    static var name = "name"
    static var image = "image"
    static var body = "body"
    static var type = "type"
}

public enum RequestImage: String {
    case RequestImageColor = "ri-light-bulb"
    case RequestImageSequence = "ri-files"
    case RequestImageMusic = "ri-music"
}

public class Request: NSObject, NSCoding, NSCopying {
    public static var hostname: String! {
        didSet {
            print("hostname: \(hostname)")
            UserDefaults.standard.set(hostname, forKey: "lastHostname")
        }
    }
    
    public static var port: String! {
        didSet {
            print("port: \(port)")
            UserDefaults.standard.set(port, forKey: "lastPort")
        }
    }
    
    public static var nextUID = 0
    
    public var endpoint: String { return "/api/v1/s/static-light" }
    public var isEditable: Bool { return true }
    public var name: String
    public var image: RequestImage
    public var body: [String: Any]
    public var uid: Int
    
    public init(name: String, image: RequestImage) {
        self.name = name
        self.image = image
        self.body = [:]
        uid = Request.nextUID
        Request.nextUID += 1
    }
    
    public func copy(with zone: NSZone?) -> Any {
        return type(of: self).init(copyFrom: self)
    }
    
    required public init(copyFrom: Request) {
        self.name = copyFrom.name
        self.image = copyFrom.image
        self.body = copyFrom.body
        uid = Request.nextUID
        Request.nextUID += 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String
        image = RequestImage(rawValue: aDecoder.decodeObject(forKey: PropertyKey.image) as! String)!
        body = aDecoder.decodeObject(forKey: PropertyKey.body) as! [String: Any]
        uid = Request.nextUID
        Request.nextUID += 1
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(image.rawValue, forKey: PropertyKey.image)
        aCoder.encode(body, forKey: PropertyKey.body)
    }
    
    public static func ==(lsr: Request, rhr: Request) -> Bool{
        return lsr.uid == rhr.uid
    }
    
    public func send(callback: ((Error?) -> Void)!) {
        if let hostname = Request.hostname, let port = Request.port {
            Alamofire.request("http://" + hostname + ":" + port + endpoint, method: .post, parameters: self.body, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
                if (callback != nil) {
                    callback(response.error)
                }
            }
        } else {
            fatalError("The endpoint was never initially set. This should be done by LoginViewController.")
        }        
    }
}



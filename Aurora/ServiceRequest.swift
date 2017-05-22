//
//  ServiceRequest.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/24/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

public extension PropertyKey {
    static var service = "service"
    static var start = "start"
}

public enum ServiceType: String {
    case StaticLightService = "static_light"
    case LightShowService = "light_show"
}

public class ServiceRequest: Request {
    public var service: ServiceType
    public var start: Bool = true
    override public var body: [String: Any] {
        get {
            return ["status": (start ? "started" : "stopped")]
        }
        set(new){ fatalError("Set body through the service and start properties.") }
    }
    override public var endpoint: String { get { return "/api/v1/services/" + service.rawValue } }
    
    public init(name: String, service: ServiceType) {
        self.service = service
        super.init(name: name, image: RequestImage.RequestImageMusic)
    }
    
    required public init(copyFrom: Request) {
        let old = copyFrom as! ServiceRequest
        self.service = old.service
        super.init(copyFrom: copyFrom)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        service = ServiceType(rawValue: aDecoder.decodeObject(forKey: PropertyKey.service) as! String)!
        start = aDecoder.decodeBool(forKey: PropertyKey.start)
        super.init(coder: aDecoder)
    }
    
    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(service.rawValue, forKey: PropertyKey.service)
        aCoder.encode(start, forKey: PropertyKey.start)
    }
}

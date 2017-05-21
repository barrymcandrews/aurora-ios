//
//  ServiceRequest.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/24/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

extension PropertyKey {
    static var service = "service"
    static var start = "start"
}

enum ServiceType: String {
    case StaticLightService = "static_light"
    case LightShowService = "light_show"
}

class ServiceRequest: Request {
    var service: ServiceType
    var start: Bool = true
    override var body: [String: Any] {
        get {
            return ["status": (start ? "started" : "stopped")]
        }
        set(new){ fatalError("Set body through the service and start properties.") }
    }
    override var endpoint: String { get { return "/api/v1/services/" + service.rawValue } }
    
    init(name: String, service: ServiceType) {
        self.service = service
        super.init(name: name, image: RequestImage.RequestImageMusic)
    }
    
    required init(copyFrom: Request) {
        let old = copyFrom as! ServiceRequest
        self.service = old.service
        super.init(copyFrom: copyFrom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        service = ServiceType(rawValue: aDecoder.decodeObject(forKey: PropertyKey.service) as! String)!
        start = aDecoder.decodeBool(forKey: PropertyKey.start)
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(service.rawValue, forKey: PropertyKey.service)
        aCoder.encode(start, forKey: PropertyKey.start)
    }
}

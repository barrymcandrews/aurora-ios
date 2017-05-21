//
//  SequenceRequest.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/23/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

extension PropertyKey {
    static var sequence = "sequence"
    static var isFade = "isFade"
    static var delay = "delay"
    static var repeats = "repeats"
    static var isParsed = "isParsed"
}

class SequenceRequest: Request {
    override var isEditable: Bool { get{ return !isParsed } }
    var sequence: [Request]
    var isFade: Bool
    var delay: Double
    var repeats: Int
    var isParsed: Bool
    
    
    override var body: [String : Any] {
        get {
            return SequenceRequest.sequenceWithItems(sequence, fade: isFade, repeats: repeats, delay: delay)
        }
        set(newBody) { fatalError("Set body through the sequence property.") }
    }
    
    init(name: String, delay: Double, fade: Bool, repeats: Int, items: [Request], parsed: Bool = false) {
        self.sequence = items
        self.isFade = fade
        self.delay = delay
        self.repeats = repeats
        self.isParsed = parsed
        super.init(name: name, image: RequestImage.RequestImageSequence)
    }
    
    required init(copyFrom: Request) {
        let old = copyFrom as! SequenceRequest
        self.sequence = old.sequence
        self.isFade = old.isFade
        self.delay = old.delay
        self.repeats = old.repeats
        self.isParsed = old.isParsed
        super.init(copyFrom: copyFrom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        sequence = aDecoder.decodeObject(forKey: PropertyKey.sequence) as! [Request]
        isFade = aDecoder.decodeBool(forKey: PropertyKey.isFade)
        delay = aDecoder.decodeDouble(forKey: PropertyKey.delay)
        repeats = aDecoder.decodeInteger(forKey: PropertyKey.repeats)
        isParsed = aDecoder.decodeBool(forKey: PropertyKey.isParsed)
        super.init(coder: aDecoder)
    }
    
    convenience init(name: String, dict: [String: Any]) {
        let fade = (dict["type"] as? String == "fade")
        var items: [Request] = []
        
        if let sequence = dict[(fade ? "colors" : "sequence")] as? [[String : Any]] {
            for req in sequence {
                let type = req["type"] as? String
                if (fade || type == "color") {
                    items.append(ColorRequest(dict: req))
                } else if (type == "sequence"  || type == "fade"){
                    items.append(SequenceRequest(name: name + "-Sub", dict: req))
                }
            }
        }
        
        let repeats = (dict["repeat"] == nil ? 1 : dict["repeat"] as! Int)
        let delay = (dict["delay"] is Int ? Double(dict["delay"] as! Int) : dict["delay"] as! Double)
        self.init(name: name, delay: delay, fade: fade, repeats: repeats, items: items, parsed: true)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(sequence, forKey: PropertyKey.sequence)
        aCoder.encode(isFade, forKey: PropertyKey.isFade)
        aCoder.encode(delay, forKey: PropertyKey.delay)
        aCoder.encode(repeats, forKey: PropertyKey.repeats)
        aCoder.encode(isParsed, forKey: PropertyKey.isParsed)
    }
    
    static func sequenceWithItems(_ items: [Request], fade: Bool, repeats: Int, delay: Double) -> [String: Any] {
        var contents: [[String: Any]] = []
        for request in items {
            if (fade) {
                if request is ColorRequest {
                    contents.append(request.body)
                }
            } else {
                contents.append(request.body)
            }
        }
        
        return [
            "type": (fade ? "fade" : "sequence"),
            "delay": delay,
            "repeat": repeats,
            (fade ? "colors" : "sequence"): contents
        ] as [String : Any]
    }
    
    
    //TODO: Override send if content-type changes
}

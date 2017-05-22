//
//  ColorRequest.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/23/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

extension PropertyKey {
    static var color = "color"
}

public class ColorRequest: Request {
    public var color: UIColor
    override public var body: [String : Any] {
        get {
            return ColorRequest.bodyForColor(color)
        }
        set(newBody) { fatalError("Set body through the color property.") }
    }
    
    public init(name: String, color: UIColor) {
        self.color = color
        super.init(name: name, image: RequestImage.RequestImageColor)
    }
    
    required public init(copyFrom: Request) {
        self.color = (copyFrom as! ColorRequest).color
        super.init(copyFrom: copyFrom)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        color = aDecoder.decodeObject(forKey: PropertyKey.color) as! UIColor
        super.init(coder: aDecoder)
    }
    
    public convenience init(color: UIColor) {
        self.init(name: color.description, color: color)
    }
    
    convenience init(dict: [String: Any]) {
        let red = dict["red"] as! Int
        let green = dict["green"] as! Int
        let blue = dict["blue"] as! Int
        let color = UIColor(red: CGFloat(Double(red)/100.0), green: CGFloat(Double(green)/100.0), blue: CGFloat(Double(blue)/100.0), alpha: 1)
        self.init(color: color)
    }
    
    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(color, forKey: PropertyKey.color)
    }
    
    static func bodyForColor(_ color: UIColor) -> [String: Any] {
        let components = color.components
        let body:[String: Any] = ["type": "color",
                                  "red": Int(components.red * 100.0),
                                  "green": Int(components.green * 100.0),
                                  "blue": Int(components.blue * 100.0)]
        return body
    }
}

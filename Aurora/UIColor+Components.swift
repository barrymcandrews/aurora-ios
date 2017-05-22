//
//  UIColor+Components.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/14/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

public extension UIColor {

    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}

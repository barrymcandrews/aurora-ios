//
//  PaddedTextField.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/15/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

@IBDesignable
class PaddedTextField: UITextField {

    @IBInspectable public var padding: CGFloat = 0.0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }

}

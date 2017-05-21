//
//  UILabel+Animations.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/15/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setText(_ newText: String, color: UIColor) {
        UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.text = newText
            self.textColor = color
        }, completion: nil)
    }
}

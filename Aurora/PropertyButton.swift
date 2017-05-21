//
//  PropertyButton.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/9/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

class PropertyButton: UIButton {
    override var canBecomeFirstResponder: Bool { get{ return true } }

    private var iv: UIView?
    override var inputView: UIView? {
        get {
            return self.iv
        }
        set(new) {
            self.iv = new
        }
        
    }
    
    private var iav: UIView?
    override var inputAccessoryView: UIView? {
        get {
            return self.iav
        }
        set(new) {
            self.iav = new
        }
        
    }
    
    var keyText: String = "" {
        didSet {
            updateTitle()
        }
    }
    
    var valueText: String = "" {
        didSet {
            updateTitle()
        }
    }
    
    var checked: Bool = false {
        didSet {
            valueText = (checked ? "Yes" : "No")
        }
    }
    
    func updateTitle() {
        let attr: [String: Any] = [NSFontAttributeName: UIFont(name: "Futura-Medium", size: 15.0)!, NSForegroundColorAttributeName: UIColor.white]
        let key = NSMutableAttributedString(string: keyText + ": ", attributes: attr)
        
        let attr2: [String: Any] = [NSFontAttributeName: UIFont(name: "Futura-MediumItalic", size: 15.0)! , NSForegroundColorAttributeName: UIColor.white]
        let value = NSAttributedString(string: valueText, attributes: attr2)
        
        key.append(value)
        self.setAttributedTitle(key, for: .normal)
    }
    
    func toggleChecked() -> Bool {
        checked = !checked
        return checked
    }
}

//
//  UIView+Animations.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/14/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    func shake(duration: CFTimeInterval) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        translation.duration = duration
        self.layer.add(translation, forKey: "shakeIt")
    }
    
    func setHidden(hidden: Bool, duration: Double) {
        UIView.transition(with: self, duration: duration, options: [.transitionCrossDissolve], animations: {
            self.isHidden = hidden
        }, completion: nil)
    }
    
    func hide(_ duration: Double) { self.setHidden(hidden: true, duration: duration) }
    
    func show(_ duration: Double) { self.setHidden(hidden: false, duration: duration) }
    
    
    // Removes all children from the view and adds the new view as the only child
    func embedView(_ view: UIView) {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(view)
    }
}

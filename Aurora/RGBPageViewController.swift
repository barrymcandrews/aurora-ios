//
//  RGBPageViewController.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/5/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore
import ColorPicker

class RGBPageViewController: UIViewController, RequestMaker {
    @IBOutlet weak var colorInfoView: HRColorInfoView!
    @IBOutlet weak var redBrightnessSlider: HRBrightnessSlider!
    @IBOutlet weak var greenBrightnessSlider: HRBrightnessSlider!
    @IBOutlet weak var blueBrightnessSlider: HRBrightnessSlider!
    
    var initialRequest: Request?
    
    var color: UIColor {
        get {
            let red = CGFloat(redBrightnessSlider.brightness)
            let green = CGFloat(greenBrightnessSlider.brightness)
            let blue = CGFloat(blueBrightnessSlider.brightness)
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        
        set(newColor) {
            colorInfoView.color = newColor
            redBrightnessSlider.brightness = NSNumber(value: Double(newColor.components.red))
            greenBrightnessSlider.brightness = NSNumber(value: Double(newColor.components.green))
            blueBrightnessSlider.brightness = NSNumber(value: Double(newColor.components.blue))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redBrightnessSlider.addTarget(self, action: #selector(colorSliderChanged), for: .valueChanged)
        greenBrightnessSlider.addTarget(self, action: #selector(colorSliderChanged), for: .valueChanged)
        blueBrightnessSlider.addTarget(self, action: #selector(colorSliderChanged), for: .valueChanged)
        updateInfoColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let colorRequest = initialRequest as? ColorRequest {
            self.color = colorRequest.color
        }
    }
    
    
    func buildRequest() -> Request {
        return ColorRequest(color: self.color)
    }
    
    func updateInfoColor() {
        colorInfoView.color = self.color
    }
    
    func colorSliderChanged(sender: AnyObject?) {
        updateInfoColor()
    }
}

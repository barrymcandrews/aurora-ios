//
//  ColorPageViewController.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/4/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore
import ColorPicker

protocol HuePageDelegate {
    func pickerTapped(sender: Any?)
}

class HuePageViewController: UIViewController, RequestMaker {
    @IBOutlet weak var colorPickerView: HRColorPickerView!
    @IBOutlet weak var colorMapView: HRColorMapView!
    var initialRequest: Request?
    var delegate: HuePageDelegate?
    
    static var preloaded: HuePageViewController = UIStoryboard(name: "Editors", bundle: Bundle.main).instantiateViewController(withIdentifier: "ColorPage") as! HuePageViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorMapView.tileSize = 1
        colorMapView.saturationUpperLimit = 0.5
        colorPickerView.addTarget(self, action: #selector(viewTapped), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let colorRequest = initialRequest as? ColorRequest {
            colorPickerView.color = colorRequest.color
        }
    }
    
    func buildRequest() -> Request {
         return ColorRequest(color: colorPickerView.color!)
    }
    
    func viewTapped() {
        if let delegate = self.delegate {
            delegate.pickerTapped(sender: self)
        }
    }
}

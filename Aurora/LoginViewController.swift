//
//  LoginViewController.swift
//  Aurora
//
//  Created by Barry McAndrews on 3/24/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bottomDistanceConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleDistanceConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    var request: Alamofire.Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

        portTextField.inputAccessoryView = UIToolbar()
        addressTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleDistanceConstraint.constant = (self.view.frame.height - 350 - 42)/2
        if let hn = Request.hostname {
            addressTextField.text = hn
        }
        
        if let p = Request.port, p != "5000" {
            portTextField.text = p
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func connectButtonPressed(_ sender: Any) {
        if (DEBUG) { self.performSegue(withIdentifier: "showMain", sender: self) }
       
        request?.suspend()
        
        let port = (portTextField.text! == "" || Int(portTextField.text!) == nil) ? "5000" : portTextField.text!
        
        if (addressTextField.text == "") {
            subtitleLabel.setText("Address field can not be left blank.", color: UIColor.flatRed())
            addressTextField.shake(duration: 0.5)
            return
        }
    
        subtitleLabel.setText("Connecting...", color: UIColor.flatGray())
        let address = "http://" + addressTextField.text! + ":" + port
        request = Alamofire.request(address + "/api/v1/services").responseJSON(completionHandler: {(response) -> Void in
            if (response.error != nil) {
                self.subtitleLabel.setText((response.error?.localizedDescription)!, color: UIColor.flatRed())
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
            } else {
                Request.hostname = self.addressTextField.text!
                Request.port = port
                WatchSessionManager.shared.updateApplicationContext()
                self.performSegue(withIdentifier: "showMain", sender: self)
            }
            self.addressTextField.isEnabled = true
            self.portTextField.isEnabled = true
        })
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        self.subtitleLabel.text = "Enter the server information below."
    }
    
    
    // MARK: - Text Field Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let bottomSize = keyboardSize.height
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.bottomDistanceConstraint.constant = bottomSize
                self.view.layoutIfNeeded()
            })
        }
       
    }
    
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.bottomDistanceConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    func dismissKeyboard() {
        addressTextField.resignFirstResponder()
        portTextField.resignFirstResponder()
    }
}

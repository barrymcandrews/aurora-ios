//
//  CreatorViewController.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/1/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

class EditorViewController: ModalViewController, UITextFieldDelegate, HuePageDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    var containerViewController: ContainerViewController!
    var initialRequest: Request?
    @IBOutlet weak var segmentedControl: SegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This is such bad practice but the annoying af color picker has forced my hand
        HuePageViewController.preloaded.delegate = self
        
        titleTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        segmentedControl.addTarget(self, action: #selector(pageValueChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (initialRequest is SequenceRequest) {
            segmentedControl.selectedIndex = 2
        }
    }

    func pageValueChanged(sender: AnyObject?) {
        self.containerViewController.setPage(ContainerPage(rawValue: self.segmentedControl.selectedIndex)!)
    }
    
    @IBAction func testButtonPressed(_ sender: Any) {
        containerViewController.buildRequest().send(callback: nil)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if (titleTextField.text == "") {
            titleTextField.shake(duration: 0.5)
            return
        }
        
        let request = containerViewController.buildRequest()
        request.name = titleTextField.text!
        
        if (initialRequest == nil) {
            RequestContainer.shared.requests.append(request)
            print(RequestContainer.shared.requests.count)
        } else {
            var found = false
            for (index, req) in RequestContainer.shared.requests.enumerated() {
                if (req == initialRequest) {
                    RequestContainer.shared.requests[index] = request
                    found = true
                }
            }
            
            if (!found) { RequestContainer.shared.requests.append(request) }
        }
        self.hero_dismissViewController()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.hero_dismissViewController()
    }
    
    func dismissKeyboard() {
        titleTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EmbedSegue") {
            containerViewController = segue.destination as! ContainerViewController
            if (initialRequest != nil) {
                titleTextField.text = initialRequest?.name
                var page: ContainerPage
                
                if (initialRequest is ColorRequest) { page =  .huePage }
                else if (initialRequest is SequenceRequest) { page = .sequencePage }
                else { page = .huePage }
                
                containerViewController.initialRequest = initialRequest
                containerViewController.currentPage = page
            }
        }
    }
    
    //Mark: TextFieldDelegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //Mark: HuePageDelegate
    
    
    func pickerTapped(sender: Any?) {
        titleTextField.resignFirstResponder()
    }
}

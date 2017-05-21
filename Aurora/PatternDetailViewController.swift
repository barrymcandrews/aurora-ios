//
//  PatternDetailViewController.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/7/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import Charts
import Hero

class PatternDetailViewController: ModalViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var chartView = ChartDetailView()
    var sequenceView = UIView.loadFromNibNamed(nibNamed: "SequenceDetail") as! SequenceDetailView
    var serviceView = UIView.loadFromNibNamed(nibNamed: "ServiceDetail") as! ServiceDetailView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.setupContent()
        sequenceView.setupContent()
        // serviceView.setupContent() implement with ServiceView Class
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var detailView: UIView
        
        if self.request is ColorRequest {
            detailView = chartView
        } else if self.request is SequenceRequest {
            detailView = sequenceView
        } else if self.request is ServiceRequest {
            detailView = serviceView
        } else {
            detailView = UIView()
        }
        
        if let prepView = detailView as? DetailView {
            subtitleLabel.text = prepView.subtitle
            prepView.prepareContent(context: self.request)
        }
        
        contentView.embedView(detailView)
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        contentView.hide(0.25)
        sendButton.isEnabled = false
        
        self.request.send(callback: { (error: Error?) -> Void in
            self.activityIndicator.stopAnimating()
            self.contentView.isHidden = false
            if (error != nil) {
                self.backgroundView.shake(duration: 0.7)
                self.subtitleLabel.setText("Unable to connect to the server.", color: UIColor.flatRed())
            } else {
                self.backgroundView.heroModifiers = [.translate(y: 100)]
                self.titleLabel.heroModifiers = []
                self.hero_dismissViewController()
                self.activityIndicator.stopAnimating()
                self.contentView.isHidden = true
                
                //TODO: Make this an innate part of the ServiceRequest
                if (self.request is ServiceRequest && self.request.name == "Spotify") {
                    UIApplication.shared.open(URL(string: "http://" + Request.hostname + ":8080/mopify")!)
                }
            }
            self.sendButton.isEnabled = true
        })
    }
}



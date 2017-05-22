//
//  PatternDetailViewController.swift
//  Aurora
//
//  Created by Barry McAndrews on 3/26/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore

protocol DismissalDelegate {
    func modalDismissed()
}


class ModalViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    var dismissalDelegate: DismissalDelegate?
    var request: Request!
    var cellNumber: Int = 0
    var bottomSlide: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        closeButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        if (!bottomSlide) {
            backgroundView.heroID = "pcell-" + String(cellNumber)
            backgroundView.heroModifiers = [.durationMatchLongest]
            titleLabel.heroID = "pcell-title-" + String(cellNumber)
            titleLabel.heroModifiers = [.durationMatchLongest]
        } else {
            backgroundView.heroModifiers = [.translate(y:backgroundView.frame.height)]

        }
        self.view.heroModifiers = [.fade]
        
        request = RequestContainer.shared.requests[cellNumber]
        titleLabel.text = request.name
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (dismissalDelegate != nil) {
            dismissalDelegate?.modalDismissed()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

//
//  DetailView.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/1/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore

protocol DetailView {
   
    var subtitle: String { get }
    
    // Used to setup initial layout of subviews
    func setupContent()
    
    // Called before view appears on the screen
    func prepareContent(context: Request)
}

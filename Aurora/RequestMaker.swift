//
//  EditorPage.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/4/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore

protocol RequestMaker {
    var initialRequest: Request? { get set }
    func buildRequest() -> Request
}

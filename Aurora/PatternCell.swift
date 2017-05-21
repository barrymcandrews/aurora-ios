//
//  PatternCell.swift
//  Aurora
//
//  Created by Barry McAndrews on 3/26/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

class PatternCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var heroEnabled = true
    
    var cellNumber: Int = 0 {
        didSet {
            if (heroEnabled) {
                self.heroID = "pcell-" + String(cellNumber)
                self.titleLabel.heroID = "pcell-title-" + String(cellNumber)
            }
        }
    }
}

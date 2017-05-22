//
//  SequenceDetailView.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/22/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore

class SequenceDetailView: UIView, DetailView, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var subtitle: String = "Pattern Information"
    var request: SequenceRequest?
    
    // Mark: - Preparable
    
    func setupContent() {
        itemsCollectionView.register(UINib(nibName: "SequenceDetailCell", bundle: nil), forCellWithReuseIdentifier: "subPatternCell")
    }
    
    func prepareContent(context: Request) {
        request = context as? SequenceRequest
        detailsLabel.text = "Delay: \(String(format: "%2.2f", request!.delay)) Seconds\nFade: \(request!.isFade ? "Yes" : "No")"

    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (request == nil ? 0 : request!.sequence.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subPatternCell", for: indexPath) as? PatternCell
        let req = request!.sequence[indexPath.item]
        if let colorReq = req as? ColorRequest {
            cell?.backgroundColor = colorReq.color.flatten()
            cell?.imageView.image = UIImage(named:String(RequestImage.RequestImageColor.rawValue))
        } else {
            cell?.backgroundColor = UIColor.flatGreen()
            cell?.imageView.image = UIImage(named:String(RequestImage.RequestImageSequence.rawValue))
        }
        
        return cell!
    }
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 50, height: 50)
    }
    
    //Use for interspacing
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
}

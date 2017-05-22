//
//  ViewController.swift
//  Aurora
//
//  Created by Barry McAndrews on 3/23/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore
import Chameleon
import Hero

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DismissalDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ColorPageViewController.preloaded.loadView()
        self.automaticallyAdjustsScrollViewInsets = false
        // view.heroModifiers = [.duration(0.3)]
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        headerView.backgroundColor = GradientColor(.leftToRight, frame: self.view.frame, colors: [UIColor.flatMintColorDark(), UIColor.flatGreen()])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UICollectionViewDataSource
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RequestContainer.shared.requests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "patternCell", for: indexPath as IndexPath) as! PatternCell
        let request = RequestContainer.shared.requests[indexPath.item]
        cell.cellNumber = indexPath.item
        cell.titleLabel.text = request.name
        cell.titleLabel.heroModifiers = [.durationMatchLongest]
        cell.imageView.image = UIImage(named: request.image.rawValue)
        cell.imageView.heroModifiers = [.durationMatchLongest]
        cell.heroModifiers = [.durationMatchLongest]
        
        let longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGestureRecognizer.minimumPressDuration = 1
        longPressGestureRecognizer.delegate = self
        cell.addGestureRecognizer(longPressGestureRecognizer)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "mainHeader", for: indexPath)
            return cell
        } else if (kind == UICollectionElementKindSectionFooter) {
             let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "mainFooter", for: indexPath)
            return cell
        }
        
        return UICollectionReusableView()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        //self.navigationController?.performSegue(withIdentifier: "showDetail", sender: collectionView.cellForItem(at: indexPath))
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {
            let cell = sender as! PatternCell
            let destination = segue.destination as! ModalViewController
            destination.cellNumber = cell.cellNumber
            destination.dismissalDelegate = self
        } else if (segue.identifier == "ShowEditor") {
            let editor = segue.destination as! EditorViewController
            if let ir = sender as? Request {
                editor.initialRequest = ir
            }
            editor.dismissalDelegate = self
        }
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    }
    
    // MARK: - DismissalDelegate
    
    func modalDismissed() {
        collectionView.reloadData()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.began {
            return
        }
        
        let point = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let index = indexPath {
            // var cell = self.collectionView.cellForItem(at: index) as! PatternCell
            let request = RequestContainer.shared.requests[index.item]
            
            let alertController = UIAlertController(title: "\"" + request.name + "\" Pattern", message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let editAction = UIAlertAction(title: "Edit", style: .default) { action in
                self.performSegue(withIdentifier: "ShowEditor", sender: request)
            }
            let deleteAction = UIAlertAction(title: "Delete Pattern", style: .destructive) { action in
                RequestContainer.shared.requests.remove(at: index.item)
                self.collectionView.reloadData()
            }

            if (request.isEditable) { alertController.addAction(editAction) }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true)
            
        } else {
            print("Could not find index path")
        }
    

    }
}


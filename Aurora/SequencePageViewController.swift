//
//  SequencePageViewController.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/4/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore
import DZNEmptyDataSet

class SequencePageViewController: UIViewController, RequestMaker, UICollectionViewDelegate, DragAndDropCollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    @IBOutlet weak var fadeButton: PropertyButton!
    @IBOutlet weak var delayButton: PropertyButton!
    @IBOutlet weak var patternCollectionView: DragAndDropCollectionView!
    @IBOutlet weak var sourceCollectionView: DragAndDropCollectionView!
    var picker: DelayPickerView!
    var initialRequest: Request?
    
    var data: [[Request]] = [[], []]
    
    var dragAndDropManager: DragAndDropManager?
    var isFade: Bool = false
    var delay: Double = 1.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadSourceRequests()
        
        fadeButton.keyText = "Fade Colors"
        fadeButton.valueText = "No"
        
        delayButton.keyText = "Delay"
        delayButton.valueText = "1 sec"
        
        //Picker View
        picker = DelayPickerView(frame: CGRect(x:0, y:200, width: view.frame.width, height:216))
        picker.doneAction = #selector(pickerCompleted(_:))
        picker.cancelAction = #selector(pickerDismiss)
        picker.actionObserver = self
        delayButton.inputView = picker
        delayButton.inputAccessoryView = picker.toolBar
        
        
        patternCollectionView.dataSource = self
        patternCollectionView.delegate = self
        patternCollectionView.emptyDataSetSource = self
        patternCollectionView.emptyDataSetDelegate = self
        sourceCollectionView.dataSource = self
        sourceCollectionView.delegate = self
        sourceCollectionView.sourceContainer = true
        
        patternCollectionView.register(UINib(nibName: "PatternCell", bundle: nil), forCellWithReuseIdentifier: "patternCell")
        sourceCollectionView.register(UINib(nibName: "PatternCell", bundle: nil), forCellWithReuseIdentifier: "patternCell")
        self.dragAndDropManager = DragAndDropManager(canvas: self.view, collectionViews: [patternCollectionView, sourceCollectionView])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let seqRequest = initialRequest as? SequenceRequest {
            data[patternCollectionView.tag] = seqRequest.sequence
        }
    }
    
    
    //MARK: RequestMaker
    
    func buildRequest() -> Request {
        return SequenceRequest(name: "", delay: delay, fade: isFade, repeats: 1, items: data[patternCollectionView.tag])
    }
    
    
    //MARK: Button Handlers
    
    @IBAction func fadeButtonPressed(_ sender: PropertyButton) {
        isFade = fadeButton.toggleChecked()
        self.loadSourceRequests()
        self.filterPatternRequests()
        sourceCollectionView.reloadData()
        patternCollectionView.reloadData()
    }
    
    @IBAction func delayButtonPressed(_ sender: PropertyButton) {
        delayButton.becomeFirstResponder()
    }
    
    func loadSourceRequests() {
        data[1].removeAll()
        for r in RequestContainer.shared.requests where r is ColorRequest || (r is SequenceRequest && !isFade) {
            data[1].append(r)
        }
    }
    
    func filterPatternRequests() {
        if (isFade) {
            for (index, r) in data[0].enumerated() where !(r is ColorRequest) {
                data[0].remove(at: index)
            }
        }
    }
    
    func pickerCompleted(_ value: Double) {
        delayButton.resignFirstResponder()
        self.delay = value
        delayButton.valueText = String(describing: delay) + " sec"
    }
    
    func pickerDismiss() {
        delayButton.resignFirstResponder()
    }
    
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 100, height: 100)
    }
    
    
    //MARK: UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[collectionView.tag].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let request = data[collectionView.tag][indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "patternCell", for: indexPath) as! PatternCell
        
        cell.heroEnabled = false
        cell.cellNumber = indexPath.item
        cell.titleLabel.text = request.name
        cell.imageView.image = UIImage(named: request.image.rawValue)
        cell.isHidden = false
        
        if (indexPath == (collectionView as! DragAndDropCollectionView).draggingCellIndexPath) {
            cell.isHidden = true
        }
    
        return cell
    }
    
    //MARK: DragAndDropCollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        let request = dataItem as! Request
        
        for r in data[collectionView.tag] {
            if r == request {
                let position = data[collectionView.tag].index(of: r)!
                return IndexPath(item: position, section: 0)
            }
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        return data[collectionView.tag][indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to : IndexPath) {
        let element = data[collectionView.tag][from.item]
        data[collectionView.tag].remove(at: from.item)
        data[collectionView.tag].insert(element, at: to.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) {
        let newItem = dataItem as! Request
        data[collectionView.tag].insert(newItem, at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, replaceDataItemWithCopyatIndexPath indexPath: IndexPath) {
        data[collectionView.tag][indexPath.item] = data[collectionView.tag][indexPath.item].copy() as! Request
    }

    
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: IndexPath) {
        data[collectionView.tag].remove(at: indexPath.item)
    }
    
    // MARK: EmptyCollectionView
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attr: [String: Any] = [NSFontAttributeName: UIFont(name: "Futura-MediumItalic", size: 30.0)!, NSForegroundColorAttributeName: UIColor.flatWhiteColorDark()]
        return NSAttributedString(string: "DRAG ITEMS HERE", attributes: attr)
    }

}

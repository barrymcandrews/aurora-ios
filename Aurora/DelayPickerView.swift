//
//  DelayPicker.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/10/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit

class DelayPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var choices = [4, 2, 1, 0.5, 0.25, 0.125]
    var toolBar: UIToolbar = UIToolbar()
    
    var doneAction: Selector?
    var cancelAction: Selector?
    var actionObserver: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.flatNavyBlue()
        showsSelectionIndicator = true
        
        delegate = self
        dataSource = self
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.barTintColor = UIColor.flatNavyBlueColorDark()
        toolBar.tintColor = UIColor.flatGreen()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerCancel))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pickerDone() {
        if actionObserver != nil && doneAction != nil {
            actionObserver!.perform(doneAction, with: choices[self.selectedRow(inComponent: 0)])
        }
    }
    
    func pickerCancel() {
        if actionObserver != nil && cancelAction != nil {
            actionObserver!.perform(cancelAction)
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = String(describing: choices[row]) + " Seconds"
        return NSAttributedString(string: string, attributes: [NSFontAttributeName: UIFont(name: "Futura-Medium", size: 18.0)!, NSForegroundColorAttributeName:UIColor.white])
    }
}

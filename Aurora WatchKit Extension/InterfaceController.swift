//
//  InterfaceController.swift
//  Aurora WatchKit Extension
//
//  Created by Barry McAndrews on 4/30/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import AuroraCore
import WatchKit
import Foundation
// import WatchConnectivity

class InterfaceController: WKInterfaceController, RequestContainerDelegate {
    
    @IBOutlet var tableView: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        RequestContainer.shared.delegate = self
        loadTableData()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let requests = RequestContainer.shared.requests
        requests[rowIndex].send(callback: {(error) -> Void in
            
        })
    }

    func loadTableData() {
        let requests = RequestContainer.shared.requests
        tableView.setNumberOfRows(requests.count, withRowType: "TableRow")
        for (index, request) in requests.enumerated() {
            let row = tableView.rowController(at: index) as! TableRow
            row.imageView.setImage(UIImage(named: request.image.rawValue))
            row.label.setText(request.name)
        }
    }
 
    func requestsChanged() {
        loadTableData()
        //TODO: Reduce image flickering by only loading new rows
    }
}

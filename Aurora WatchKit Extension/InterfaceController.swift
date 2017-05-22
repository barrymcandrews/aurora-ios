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

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var tableView: WKInterfaceTable!
    let requests = RequestContainer.shared.requests
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
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
        requests[rowIndex].send(callback: {(error) -> Void in
            
        })
    }

    func loadTableData() {
        tableView.setNumberOfRows(requests.count, withRowType: "TableRow")
        // let firstRow = tableView.rowController(at: 0) as! TableRow
        // firstRow.imageView.setImage(UIImage())
        // firstRow.label.setText("Custom")
        
        for (index, request) in requests.enumerated() {
            let row = tableView.rowController(at: index) as! TableRow
            row.imageView.setImage(UIImage(named: request.image.rawValue))
            row.label.setText(request.name)
        }
    }
    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        
//    }
//    
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//        DispatchQueue.main.async() {
//            
//        }
   // }
}

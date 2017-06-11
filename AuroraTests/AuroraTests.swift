//
//  AuroraTests.swift
//  AuroraTests
//
//  Created by Barry McAndrews on 3/23/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import XCTest
import AuroraCore
@testable import Aurora

class AuroraTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSendRequest() {
        let e = expectation(description: "Web Request")
        let req = ColorRequest(name: "Red", color: UIColor.red)
        req.send(callback: { (error) -> Void in
            print(error ?? "Error: none")
            XCTAssertNil(error)
            e.fulfill()
        })
        waitForExpectations(timeout: 500, handler: nil)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

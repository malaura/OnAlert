//
//  onalertUITests.swift
//  onalertUITests
//
//  Created by Maria Laura Rodriguez on 2/27/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//

import XCTest

class onalertUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSubmitDefaultPin() {
        let app = XCUIApplication()
        let mapButton = app.navigationBars["onalert.SegmentedView"].buttons["Map"]
        mapButton.tap()
        app.toolbars.buttons["Report a Crime"].tap()
        
        var tablesQuery = app.tables
        
        tablesQuery.buttons["Submit"].tap()
        
        app.navigationBars["onalert.SegmentedView"].buttons["List"].tap()
        tablesQuery = app.tables
        let count = tablesQuery.cells.count
        XCTAssertGreaterThan(count, 0, "Table view cells is 0")
    }
    
    func testSubmitTwoDefaultPins() {
        let app = XCUIApplication()
        let mapButton = app.navigationBars["onalert.SegmentedView"].buttons["Map"]
        mapButton.tap()
        app.toolbars.buttons["Report a Crime"].tap()
        
        var tablesQuery = app.tables
        
        tablesQuery.buttons["Submit"].tap()
        
        app.toolbars.buttons["Report a Crime"].tap()
        
        tablesQuery.buttons["Submit"].tap()
        
        app.navigationBars["onalert.SegmentedView"].buttons["List"].tap()
        tablesQuery = app.tables
        let count = tablesQuery.cells.count
        XCTAssertGreaterThan(count, 1, "Table view cells is 0")
    }
}

//
//  onalertTests.swift
//  onalertTests
//
//  Created by Maria Laura Rodriguez on 2/27/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//

import XCTest
@testable import onalert

class onalertTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCrimeFetchedResultsController(){
        try! CrimeService.shared.createCrime(latitude: 122, longitude: 122, type: "Assault", time: NSDate() as Date, picture: nil, comment: "", id: " ")
        let service = try! CrimeService.shared.crimeFetchedResultsController(with: MapViewController())
        if let sections = service.sections?.count {
            XCTAssertGreaterThan(sections , 0, "Number of sections in crimeFetchedResultsController was 0")
        } else {
            XCTFail("Failed to unwrap crimeFetchedResultsController sections")
        };
        
        for i in (service.sections)!{
            XCTAssertGreaterThan(i.numberOfObjects , 0, "Number of objects in sections for crimeFetchedResultsController was 0")
        }
    }
    
    func testDayCrimeCrimeFetchedResultsController(){
        // create crime
        try! CrimeService.shared.createCrime(latitude: 122, longitude: 122, type: "Assault", time: NSDate() as Date, picture: nil, comment: "", id: " ")
        let service = try! CrimeService.shared.dayCrimeFetchedResultsController(with: MapViewController())
        if let sections = service.sections?.count {
            XCTAssertGreaterThan(sections , 0, "Number of sections in dayCrimeFetchedResultsController was 0")
        } else {
            XCTFail("Failed to unwrap dayCrimeFetchedResultsController sections")
        };
        
        for i in (service.sections)!{
            XCTAssertGreaterThan(i.numberOfObjects , 0, "Number of objects in sections for dayCrimeFetchedResultsController was 0")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
}

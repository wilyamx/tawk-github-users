//
//  TWKCoreDataTests.swift
//  Github-UsersTests
//
//  Created by William S. Rena on 3/6/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import XCTest

class TWKCoreDataTests: XCTestCase {

    var coreDataStack: CoreDataStack!
    
    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

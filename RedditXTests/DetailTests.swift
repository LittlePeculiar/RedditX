//
//  DetailTests.swift
//  RedditXTests
//
//  Created by Gina Mullins on 9/19/20.
//

import UIKit
import XCTest

class DetailTests: XCTestCase {
    private var webExpectation :XCTestExpectation!
    private var webSuccess: Bool!

    override func setUpWithError() throws {
        webExpectation = XCTestExpectation(description: "fetch Complete")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    

}


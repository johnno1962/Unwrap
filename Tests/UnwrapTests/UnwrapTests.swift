//
//  UnwrapTests.swift
//  Unwrap
//
//  Created by John Holdsworth on 31/12/2020.
//  Copyright © 2020 John Holdsworth. All rights reserved.
//

import XCTest
@testable import Unwrap

final class UnwrapTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let empty: String? = nil
        _ = unwrap(empty, "Should never be empty")
        XCTFail("Should have trapped")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

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
        var empty: String? = "value"
        XCTAssertEqual(forceUnwrap(empty, "Should never be empty"), "value")
        _ = NSRegularExpression(static: "(")
        _ = URL(static: "##")
        XCTFail("Should have trapped")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

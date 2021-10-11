//
//  UnwrapTests.swift
//  Unwrap
//
//  Created by John Holdsworth on 31/12/2020.
//  Copyright © 2020 John Holdsworth. All rights reserved.
//
//  $Id: //depot/Unwrap/Tests/UnwrapTests/UnwrapTests.swift#4 $
//

import XCTest
import Unwrap
import Foundation

final class UnwrapTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var empty: String? = "value"
        XCTAssertEqual(forceUnwrap(empty, "Should never be empty"), "value")
        do {
            _ = try unwrap(empty, "Should be empty")
        } catch {
            XCTFail("Should not have thrown")
        }
        empty = nil
        URLSession.shared.dataTask(with: URL(string: "https://google.com")!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            do {
                let data = try data !! error
            } catch {
                print(error)
            }
        }.resume()

        #if true
        func showUserHelpfulErrorMessageAndQuit() {
        }
        do { // Various invocations
            _ = try URL(string: "https://google.com") !! fatalError("WTF?")
            _ = try URL(string: "https://google.com") !! NSError(domain: "WTF", code: -2, userInfo: nil)
            _ = try URL(string: "https://google.com") !! { throw NSError(domain: "WTF", code: -2, userInfo: nil) }
            _ = try URL(string: "https://google.com") !! "WTF?"
            _ = try URL(string: "https://google.com") !! showUserHelpfulErrorMessageAndQuit()
            _ = try URL(string: "https://google.com").unwrapped(orThrow: fatalError("WTF?"))
            _ = try URL(string: "https://google.com").unwrapped(orThrow: NSError(domain: "WTF", code: -2, userInfo: nil))
            _ = try URL(string: "https://google.com").unwrapped(orThrow: { throw NSError(domain: "WTF", code: -2, userInfo: nil) })
            _ = try URL(string: "https://google.com").unwrapped(orThrow: "WTF?")
            _ = try URL(string: "https://google.com").unwrapped(orThrow:  showUserHelpfulErrorMessageAndQuit())
        } catch {

        }
        #endif

//        return
        do {
            print(try empty !! "WTF")
            print(try empty ?? unwrapFailure(throw: "WTF"))
        } catch {
            print(error)
        }
        XCTAssertEqual(empty.unwrap(or: "OK"), "OK")
        do {
            _ = try unwrap(empty, "Should be empty")
        } catch {
            XCTAssert(true, "Should have thrown")
        }
        #if false // These would be fatal
        _ = URL(static: "##", "URL test")
        _ = NSRegularExpression(static: "(", "Regex test")
        XCTFail("Should have trapped")
        #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

//
//  Unwrap.swift
//  Unwrap
//
//  Created by John Holdsworth on 31/12/2020.
//  Copyright © 2020 John Holdsworth. All rights reserved.
//

/// Force unwrap an optional providing more debug information
/// than the '!' postfix operator.
/// - Parameters:
///   - optional: Optional to be unwrapped
///   - reasoning: Resaonsing why it should never be nil
/// - Returns: unwrapped type
public func forceUnwrap<T>(_ optional: T?, _ reasoning: String,
    file: StaticString = #file, line: UInt = #line) -> T {
    switch optional {
    case .none:
        fatalError("Forced unwrap of type \(T?.self) asserting '\(reasoning)' failed", file: file, line: line)
    case .some(let unwrapped):
        return unwrapped
    }
}

import Foundation

extension URL {
    /// Non-optional URL initialiser taking StaticString.
    /// - Parameter static: Hard coded URL static string.
    public init(static string: StaticString,
                file: StaticString = #file, line: UInt = #line) {
        self = forceUnwrap(URL(string: string.description),
                           "Valid static URL string \"\(string)\"",
                           file: file, line: line)
    }
}

extension NSRegularExpression {
    convenience init(static pattern: StaticString,
                     options: NSRegularExpression.Options = [],
                     file: StaticString = #file, line: UInt = #line) {
        do {
            try self.init(pattern: pattern.description, options: options)
        } catch {
            fatalError("Invalid static regex pattern \"\(pattern)\": \(error)",
                       file: file, line: line)
        }
    }
}

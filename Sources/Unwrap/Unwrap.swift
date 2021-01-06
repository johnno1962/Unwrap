//
//  Unwrap.swift
//  Unwrap
//
//  Created by John Holdsworth on 31/12/2020.
//  Copyright © 2020 John Holdsworth. All rights reserved.
//
//  Experimental alternative to force unwrapping in code.
//  =====================================================
//
//  $Id: //depot/Unwrap/Sources/Unwrap/Unwrap.swift#1 $
//

import Foundation

/// Force unwrap an optional providing more debug information
/// and more auditable than the '!' postfix operator.
/// - Parameters:
///   - optional: Optional to be unwrapped
///   - reasoning: Resaonsing why it should never be nil
/// - Returns: unwrapped type
public func forceUnwrap<T>(_ optional: T?, _ reasoning: String,
    file: StaticString = #file, line: UInt = #line) -> T {
    switch optional {
    case .none:
        fatalError(
            "Forced unwrap of type \(T?.self) asserting '\(reasoning)' failed",
            file: file, line: line)
    case .some(let unwrapped):
        return unwrapped
    }
}

/// Try to unwrap an optional providing more debug information
/// than the '!' postfix operator and throw if nil.
/// - Parameters:
///   - optional: Optional to be unwrapped
///   - reasoning: Resaonsing why it should never be nil
/// - Returns: unwrapped type
public func unwrap<T>(_ optional: T?, _ reasoning: String,
    file: StaticString = #file, line: UInt = #line) throws -> T {
    switch optional {
    case .none:
        throw NSError(domain: "Forec Unwrap", code: -1, userInfo: [
            NSLocalizedDescriptionKey:
            "Forced unwrap of type \(T?.self) asserting '\(reasoning)' failed",
            "file": file, "line": line])
    case .some(let unwrapped):
        return unwrapped
    }
}

extension URL {
    /// Non-optional URL initialiser taking StaticString.
    /// - Parameters:
    ///   - static: Hard coded URL static string.
    ///   - purpose: Usage of this constant in code.
    public init(static string: StaticString, _ purpose: StaticString,
                file: StaticString = #file, line: UInt = #line) {
        self = forceUnwrap(URL(string: string.description),
                           "URL constant \"\(string)\" for \"\(purpose)\"",
                           file: file, line: line)
    }
}

extension NSRegularExpression {
    /// Non-trowing NSRegularExpression initialiser taking StaticString.
    /// - Parameters:
    ///   - static: Hard coded regex patten.
    ///   - purpose: Usage of this constant in code.
    convenience init(static pattern: StaticString, _ purpose: StaticString,
                     options: NSRegularExpression.Options = [],
                     file: StaticString = #file, line: UInt = #line) {
        do {
            try self.init(pattern: pattern.description, options: options)
        } catch {
            fatalError("Invalid static regex pattern for \"\(purpose)\": \(error)",
                       file: file, line: line)
        }
    }
}

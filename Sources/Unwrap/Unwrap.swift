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

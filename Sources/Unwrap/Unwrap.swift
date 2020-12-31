//
//  Unwrap.swift
//  Unwrap
//
//  Created by John Holdsworth on 31/12/2020.
//  Copyright © 2020 John Holdsworth. All rights reserved.
//

public func unwrap<T>(_ optional: T?, _ reason: String,
    file: StaticString = #file, line: UInt = #line) -> T {
    guard let unwrapped = optional else {
        fatalError("Forced unwrap of type \(T?.self) asserting '\(reason)' failed", file: file, line: line)
    }
    return unwrapped
}

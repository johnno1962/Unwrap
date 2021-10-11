//
//  Unwrap.swift
//  Unwrap
//
//  Created by John Holdsworth on 31/12/2020.
//  Copyright © 2020 John Holdsworth.
//
//  Experimental alternatives to force unwrapping in code.
//  ======================================================
//
//  $Id: //depot/Unwrap/Sources/Unwrap/Unwrap.swift#17 $
//
//  Repo/SPM: https://github.com/johnno1962/Unwrap
//

import Foundation

infix operator !!: NilCoalescingPrecedence

/// Function that allows you to throw but in an expression.
/// Intended for use after nil coalescing operator in unwrap.
/// Gives fatalError in Debug builds to aid debugging and
/// throws in a Release build for app to be able to recover.
/// - Parameters:
///   - toThrow: A String, Error or closure that throws
/// - Throws: Error passed in or UnwrapError
/// - Returns: Never
public func unwrapFailure<E,T>(throw toThrow: E,
    file: StaticString = #file, line: UInt = #line) throws -> T {
    if let throwingClosure = toThrow as? () throws -> Void {
        try throwingClosure()
    }
    let toThrow = toThrow as? Error ?? Optional<T>.UnwrapError
        .forceUnwrapFailed(text: "\(toThrow)", type: Optional<T>.self,
            file: file, line: line)
    #if DEBUG
    // Fail quickly during development.
    fatalError("\(toThrow)", file: file, line: line)
    #else
    // Log and throw for a release build.
    // Gives the app a chance to recover.
    NSLog("\(toThrow)")
    throw toThrow
    #endif
}
extension Optional {
    /// An Error thrown if you don't provide one.
    public enum UnwrapError: Error {
        case forceUnwrapFailed(text: String, type: Any.Type,
            file: StaticString, line: UInt)
    }
    /// Optional "Unwrap or throw" operator if you prefer.
    /// Always fails quickly during debugging for exceptional
    /// conditions but throws in a "Release" build motivating
    /// the developer to provide an error recovery path if an
    /// Optional is nil and not just crash the application out.
    /// - Parameters:
    ///   - toUnwrap: Optional to unwrap
    ///   - alternative: Message or Error to log/throw on nil
    /// - Throws: UnwrapError showing reasoning
    /// - Returns: unwrapped value if there is one
    public static func !!<T>(toUnwrap: Optional,
                          alternative: @autoclosure () -> T) throws -> Wrapped {
        switch toUnwrap {
        case .none:
            return try unwrapFailure(throw: alternative())
        case .some(let value):
            return value
        }
    }
    /// Alternative as a fuction which has the advantage it
    /// documents the file and line number correctly.
    public func unwrapped<T>(orThrow alternative: @autoclosure () -> T,
        file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        switch self {
        case .none:
            return try unwrapFailure(throw: alternative(), file: file, line: line)
        case .some(let value):
            return value
        }
    }
}

/// Previous variations on the theme...

/// Force unwrap an optional providing more debug information
/// and more auditable than the '!' postfix operator.
/// - Parameters:
///   - optional: Optional to be unwrapped
///   - reasoning: Reasonsing why it should never be nil
/// - Returns: unwrapped type
public func forceUnwrap<T>(_ optional: T?, _ reasoning: String,
    file: StaticString = #file, line: UInt = #line) -> T {
    return optional.forceUnwrap(reasoning, file: file, line: line)
}

/// Try to unwrap an optional providing more debug information
/// than the '!' postfix operator and throw if nil.
/// - Parameters:
///   - optional: Optional to be unwrapped
///   - reasoning: Reasonsing why it should never be nil
/// - Returns: unwrapped type
public func unwrap<T>(_ optional: T?, _ reasoning: String,
    file: StaticString = #file, line: UInt = #line) throws -> T {
    return try optional.unwrap(reasoning, file: file, line: line)
}

// Alternatively as an extension on Optional (with optional reasoning)
// viz. https://github.com/JohnSundell/Require
extension Optional {
    /// Force unwrap an optional providing more debug information
    /// and more auditable than the '!' postfix operator.
    /// - Parameters:
    ///   - reasoning: Reasonsing why it should never be nil
    /// - Returns: unwrapped type
    public func forceUnwrap(_ reasoning: String = "Will never be nil",
        file: StaticString = #file, line: UInt = #line) -> Wrapped {
        switch self {
        case .none:
            fatalError(
                "Forced unwrap of type \(Wrapped?.self) asserting '\(reasoning)' failed",
                file: file, line: line)
        case .some(let unwrapped):
            return unwrapped
        }
    }

    /// Try to unwrap an optional providing more debug information
    /// than the '!' postfix operator and throw if nil.
    /// - Parameters:
    ///   - reasoning: Reasonsing why it should never be nil
    /// - Returns: unwrapped type
    public func unwrap(_ reasoning: String = "Will never be nil",
        file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        switch self {
        case .none:
            let error = NSError(domain: "Force Unwrap", code: -1, userInfo: [
                NSLocalizedDescriptionKey:
                "Forced unwrap of type \(Wrapped?.self) asserting '\(reasoning)' failed",
                "file": file, "line": line])
            #if DEBUG
            // For a Debug build this is a fatal error for investigation.
            fatalError("\(error)", file: file, line: line)
            #else
            // Otherwise, in production throw so app can recover.
            throw error
            #endif
        case .some(let unwrapped):
            return unwrapped
        }
    }

    /// Unwrap falling back to default value
    /// - Parameters:
    ///   - value: Value to use if optional in nil
    ///   - file: Source file
    ///   - line: Line number
    /// - Returns: The unwrapped value or the default value
    public func unwrap(or value: @autoclosure () -> Wrapped,
        file: StaticString = #file, line: UInt = #line) -> Wrapped {
        NSLog("Unwrap falling back to \(value()), \(file):\(line)")
        return value()
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
    convenience public init(static pattern: StaticString, _ purpose: StaticString,
                     options: NSRegularExpression.Options = [],
                     file: StaticString = #file, line: UInt = #line) {
        do {
            try self.init(pattern: pattern.description, options: options)
        } catch {
            fatalError("Invalid static regex pattern \(pattern) for \"\(purpose)\": \(error)",
                       file: file, line: line)
        }
    }
}

//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Nimble

func unwrap<A>(_ a: A?, file: FileString = #file, line: UInt = #line) -> A? {
    if let _ = a {} else { fail("Object of type \(A.self) is nil", file: file, line: line) }
    return a
}

func unwrap<A, B>(_ a: A?, _ b: B?, file: FileString = #file, line: UInt = #line) -> (A?, B?) {
    return (unwrap(a), unwrap(b))
}

func unwrap<A, B, C>(_ a: A?, _ b: B?, _ c: C?, file: FileString = #file, line: UInt = #line) -> (A?, B?, C?) {
    return (unwrap(a), unwrap(b), unwrap(c))
}

func unwrap<A, B, C, D>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, file: FileString = #file, line: UInt = #line) -> (A?, B?, C?, D?) {
    return (unwrap(a), unwrap(b), unwrap(c), unwrap(d))
}

func unwrap<A, B, C, D, E>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, file: FileString = #file, line: UInt = #line) -> (A?, B?, C?, D?, E?) {
    return (unwrap(a), unwrap(b), unwrap(c), unwrap(d), unwrap(e))
}

func unwrap<A, B, C, D, E, F>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, file: FileString = #file, line: UInt = #line) -> (A?, B?, C?, D?, E?, F?) {
    return (unwrap(a), unwrap(b), unwrap(c), unwrap(d), unwrap(e), unwrap(f))
}
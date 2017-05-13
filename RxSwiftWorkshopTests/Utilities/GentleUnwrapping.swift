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

func unwrap<A, B>(_ a: A?, _ b: B?, file: FileString = #file, line: UInt = #line) -> (A, B)? {
    guard let a = unwrap(a), let b = unwrap(b) else { return nil }
    return (a, b)
}

func unwrap<A, B, C>(_ a: A?, _ b: B?, _ c: C?, file: FileString = #file, line: UInt = #line) -> (A, B, C)? {
    guard let (a, b) = unwrap(a, b), let c = unwrap(c) else { return nil }
    return (a, b, c)
}

func unwrap<A, B, C, D>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, file: FileString = #file, line: UInt = #line) -> (A, B, C, D)? {
    guard let (a, b, c) = unwrap(a, b, c), let d = unwrap(d) else { return nil }
    return (a, b, c, d)
}

func unwrap<A, B, C, D, E>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, file: FileString = #file, line: UInt = #line) -> (A, B, C, D, E)? {
    guard let (a, b, c, d) = unwrap(a, b, c, d), let e = unwrap(e) else { return nil }
    return (a, b, c, d, e)
}

func unwrap<A, B, C, D, E, F>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, file: FileString = #file, line: UInt = #line) -> (A, B, C, D, E, F)? {
    guard let (a, b, c, d, e) = unwrap(a, b, c, d, e), let f = unwrap(f) else { return nil }
    return (a, b, c, d, e, f)
}
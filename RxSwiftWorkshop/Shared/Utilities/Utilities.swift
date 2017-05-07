//
// Created by Maciej Oczko on 03.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation

func isRunningUnitTests() -> Bool {
    let env = ProcessInfo.processInfo.environment
    if let injectBundle = env["XCInjectBundle"], let url = URL(string: injectBundle) {
        return url.pathExtension == "xctest"
    }
    return false
}

extension Collection where Indices.Iterator.Element == Index {

    subscript(safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

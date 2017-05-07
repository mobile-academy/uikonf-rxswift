//
// Created by Krzysztof Siejkowski on 07/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick

let setup: (@escaping BeforeExampleClosure) -> () = beforeEach

func condition(_ description: String, flags: FilterFlags = [:], closure: () -> Void) {
    return context(description, flags: flags, closure: closure)
}

func describes(_ description: String, flags: FilterFlags = [:], closure: () -> Void) {
    return describe(description, flags: flags, closure: closure)
}
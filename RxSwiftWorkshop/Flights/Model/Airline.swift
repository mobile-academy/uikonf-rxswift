//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Marshal

struct Airline: Unmarshaling, Equatable {
    let code: String
    let name: String

    init(code: String, name: String) {
        self.code = code
        self.name = name
    }

    init(object: MarshaledObject) throws {
        code = try object.value(for: "code")
        name = try object.value(for: "name")
    }
}

func ==(lhs: Airline, rhs: Airline) -> Bool {
    return lhs.code == rhs.code && lhs.name == rhs.name
}

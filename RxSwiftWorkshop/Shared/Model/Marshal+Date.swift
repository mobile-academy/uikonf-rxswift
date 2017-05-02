//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Marshal
import SwiftDate

extension Date : ValueType {
    public static func value(from object: Any) throws -> Date {
        guard let dateString = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
        let dateInRegion = DateInRegion(string: dateString, format: .iso8601Auto)
        guard let date = dateInRegion?.absoluteDate else {
            throw MarshalError.typeMismatch(expected: "ISO8601 date string", actual: dateString)
        }
        return date
    }
}

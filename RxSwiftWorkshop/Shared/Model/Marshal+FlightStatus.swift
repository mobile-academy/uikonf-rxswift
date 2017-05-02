//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Marshal

extension FlightStatus : ValueType {
    public static func value(from object: Any) throws -> FlightStatus {
        guard let flightStatusString = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
        guard let flightStatus = FlightStatus(code: flightStatusString) else {
            throw MarshalError.typeMismatch(expected: "FlightStatus", actual: flightStatusString)
        }
        return flightStatus
    }
}

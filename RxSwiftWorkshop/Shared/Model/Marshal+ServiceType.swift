//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Marshal

extension ServiceType: ValueType {
    public static func value(from object: Any) throws -> ServiceType {
        guard let serviceTypeString = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
        guard let serviceType = ServiceType(code: serviceTypeString) else {
            throw MarshalError.typeMismatch(expected: "ServiceType", actual: serviceTypeString)
        }
        return serviceType
    }
}

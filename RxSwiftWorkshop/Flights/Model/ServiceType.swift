//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation

enum ServiceType {
    case passengerLine // J
    case passengerCharter // C
    case freightLine // F
    case freightCharter // H

    init?(code: String) {
        switch code {
        case "J": self = .passengerLine; break
        case "C": self = .passengerCharter; break
        case "F": self = .freightLine; break
        case "H": self = .freightCharter; break
        default: return nil
        }
    }
}

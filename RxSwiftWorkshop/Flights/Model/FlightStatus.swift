//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation

enum FlightStatus: String {
    // Any flight
    case flightScheduled = "SCH"
    case cancelled = "CNX"
    case tomorrow = "TOM"

    // Arriving flights
    case airborne = "AIR"
    case expectedLanding = "EXP"
    case flightInDutchAirspace = "FIR" // -> Flight Information Region
    case landed = "LND"
    case firstBaggageSoon = "FIB"
    case arrived = "ARR"
    case diverted = "DIV"

    // Departing flights
    case delayed = "DEL"
    case waitInLounge = "WIT"
    case gateOpen = "GTO"
    case boarding = "BRD"
    case gateClosing = "GCL"
    case gateClosed = "GTD"
    case departed = "DEP"
    case gateChange = "GCH"

    init?(code: String) {
        self.init(rawValue: code)
    }
}

extension FlightStatus: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}

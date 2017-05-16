//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Marshal
import SwiftDate

struct Flight: Unmarshaling, Equatable {
    let id: Int
    let name: String
    let number: Int
    let schedule: Date
    let prefixIATA: String
    let serviceType: ServiceType

    let mainFlight: String
    let codeshares: [String]

    let terminal: Int?
    let gate: String?

    let estimatedLandingTime: Date?
    let actualLandingTime: Date?
    let publicEstimatedOffBlockTime: Date?
    let actualOffBlockTime: Date?

    let expectedTimeGateOpen: Date?
    let expectedTimeBoarding: Date?
    let expectedTimeGateClosing: Date?

    let statuses: [FlightStatus]
    let destinationCodes: [String]

    private(set) var destinations: [Airport]?

    init(
        id: Int,
        name: String,
        number: Int,
        schedule: Date,
        prefixIATA: String,
        serviceType: ServiceType,
        mainFlight: String,
        codeshares: [String],
        terminal: Int?,
        gate: String?,
        estimatedLandingTime: Date? = nil,
        actualLandingTime: Date? = nil,
        publicEstimatedOffBlockTime: Date? = nil,
        actualOffBlockTime: Date? = nil,
        expectedTimeGateOpen: Date? = nil,
        expectedTimeBoarding: Date? = nil,
        expectedTimeGateClosing: Date? = nil,
        statuses: [FlightStatus] = [],
        destinationCodes: [String] = []
    ) {
        self.id = id
        self.name = name
        self.number = number
        self.schedule = schedule
        self.prefixIATA = prefixIATA
        self.serviceType = serviceType
        self.mainFlight = mainFlight
        self.codeshares = codeshares
        self.terminal = terminal
        self.gate = gate
        self.estimatedLandingTime = estimatedLandingTime
        self.actualLandingTime = actualLandingTime
        self.publicEstimatedOffBlockTime = publicEstimatedOffBlockTime
        self.actualOffBlockTime = actualOffBlockTime
        self.expectedTimeGateOpen = expectedTimeGateOpen
        self.expectedTimeBoarding = expectedTimeBoarding
        self.expectedTimeGateClosing = expectedTimeGateClosing
        self.statuses = statuses
        self.destinationCodes = destinationCodes
    }

    init(object: MarshaledObject) throws {
        id = try object.value(for: "id")
        number = try object.value(for: "flightNumber")
        name = try object.value(for: "flightName")

        let scheduleDate: String = try object.value(for: "scheduleDate")
        let scheduleTime: String = try object.value(for: "scheduleTime")
        if let dateInRegion = DateInRegion(string: "\(scheduleDate)T\(scheduleTime)", format: .iso8601Auto) {
            schedule = dateInRegion.absoluteDate
        } else {
            schedule = Date()
        }

        prefixIATA = (try? object.value(for: "prefixIATA")) ?? ""
        serviceType = (try? object.value(for: "serviceType")) ?? .passengerLine
        mainFlight = try object.value(for: "mainFlight")
        codeshares = (try? object.value(for: "codeshares.codeshares")) ?? []

        terminal = try? object.value(for: "terminal")
        gate = try? object.value(for: "gate")

        estimatedLandingTime = try? object.value(for: "estimatedLandingTime")
        actualLandingTime = try? object.value(for: "actualLandingTime")
        publicEstimatedOffBlockTime = try? object.value(for: "publicEstimatedOffBlockTime")
        actualOffBlockTime = try? object.value(for: "actualOffBlockTime")

        expectedTimeGateOpen = try? object.value(for: "expectedTimeGateOpen")
        expectedTimeBoarding = try? object.value(for: "expectedTimeBoarding")
        expectedTimeGateClosing = try? object.value(for: "expectedTimeGateClosing")

        let statusStrings: [String] = try object.value(for: "publicFlightState.flightStates")
        statuses = statusStrings.flatMap(FlightStatus.init(code:))
        destinationCodes = try object.value(for: "route.destinations")
        destinations = nil
    }

    func with(destinations: [Airport]) -> Flight {
        var flight = self
        flight.destinations = destinations
        return flight
    }
}

extension Flight: Hashable {
    public var hashValue: Int {
        return id
    }
}

func ==(lhs: Flight, rhs: Flight) -> Bool {
    return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.number == rhs.number
        && lhs.schedule == rhs.schedule
        && lhs.prefixIATA == rhs.prefixIATA
        && lhs.serviceType == rhs.serviceType
        && lhs.mainFlight == rhs.mainFlight
        && lhs.statuses == rhs.statuses
}

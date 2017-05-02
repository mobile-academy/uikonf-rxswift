//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation

enum FlightStatus {
	// Any flight
	case flightScheduled // SCH
	case cancelled // CNX
	case tomorrow // TOM

	// Arriving flights
	case airborne // AIR
	case expectedLanding // EXP
	case flightInDutchAirspace // FIR -> Flight Information Region
	case landed // LND
	case firstBaggageSoon // FIB
	case arrived // ARR
	case diverted // DIV

	// Departing flights
	case delayed // DEL
	case waitInLounge // WIT
	case gateOpen // GTO
	case boarding // BRD
	case gateClosing // GCL
	case gateClosed // GTD
	case departed // DEP
	case gateChange // GCH

	init?(code: String) {
		switch code {
			case "SCH": self = .flightScheduled; break
			case "CNX": self = .cancelled; break
			case "TOM": self = .tomorrow; break

			// Arriving flights
			case "AIR": self = .airborne; break
			case "EXP": self = .expectedLanding; break
			case "FIR": self = .flightInDutchAirspace; break
			case "LND": self = .landed; break
			case "FIB": self = .firstBaggageSoon; break
			case "ARR": self = .arrived; break
			case "DIV": self = .diverted; break

			// Departing flights
			case "DEL": self = .delayed; break
			case "WIT": self = .waitInLounge; break
			case "GTO": self = .gateOpen; break
			case "BRD": self = .boarding; break
			case "GCL": self = .gateClosing; break
			case "GTD": self = .gateClosed; break
			case "DEP": self = .departed; break
			case "GCH": self = .gateChange; break
			default: return nil
		}
	}
}

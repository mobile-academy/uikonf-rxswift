//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxTest

@testable import RxSwiftWorkshop

final class FakeIATAService: IATACallable {
	var airportObservable: Observable<Airport>!
	var airlineObservable: Observable<Airline>!

	func airport(for code: String) -> Observable<Airport> {
		return airportObservable
	}

	func airline(for code: String) -> Observable<Airline> {
		return airlineObservable
	}
}

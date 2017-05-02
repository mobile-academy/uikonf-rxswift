//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class FlightsViewModel {
	let schipolCallable: SchipolCallable
	let iataCallable: IATACallable

	let flights: Variable<[Flight]>

	init(schipolCallable: SchipolCallable, iataCallable: IATACallable) {
		self.schipolCallable = schipolCallable
		self.iataCallable = iataCallable
		self.flights = Variable([])
	}

	func refresh() -> Disposable {
		return schipolCallable
				.flights()
				.flatMap { flights in self.updateAirports(for: flights) }
				.bind(to: flights)
	}

	private func updateAirports(for flights: [Flight]) -> Observable<[Flight]> {
		return Observable<Flight>
				.from(flights)
				.flatMap {
					flight -> Observable<Flight> in
					self.airports(from: flight.destinationCodes).map { airports in flight.with(destinations: airports) }
				}
				.toArray()
	}

	private func airports(from destinationCodes: [String]) -> Observable<[Airport]> {
		return Observable<String>
				.from(destinationCodes)
				.flatMap { code in self.iataCallable.airport(for: code) }
				.toArray()
	}
}

//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FlightsDisplayable {
    var flights: Variable<[Flight]> { get }
    func refresh(with filter: FlightsFilter?) -> Disposable
}

extension FlightsDisplayable {
    func refresh() -> Disposable {
        return refresh(with: nil)
    }
}

final class FlightsViewModel: FlightsDisplayable {
    private let disposeBag = DisposeBag()
    let schipolCallable: SchipolCallable
    let iataCallable: IATACallable

    let flights: Variable<[Flight]>

    init(schipolCallable: SchipolCallable, iataCallable: IATACallable) {
        self.schipolCallable = schipolCallable
        self.iataCallable = iataCallable
        flights = Variable([])
    }

    func refresh(with filter: FlightsFilter?) -> Disposable {
        let flightsCall = schipolCallable
            .flights(with: filter)
            .flatMap { flights in self.updateAirports(for: flights) }
            .do(onError: { print($0) })
            .catchErrorJustReturn([])
        flightsCall.bind(to: flights).disposed(by: disposeBag)
        return flightsCall.subscribe()
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

    //    private func isFlight(_ flight: Flight, matching query: String) -> Bool {
    //        guard !query.isEmpty else { return true }
    //        let lowerQuery = query.lowercased()
    //        let isNameMatchingQuery = flight.name.lowercased().contains(lowerQuery)
    //        let isAnyStatusMatchingQuery = !flight.statuses.filter { status in status.description.lowercased().contains(lowerQuery) }.isEmpty
    //        let isAnyDestinationMatchingQuery: Bool = !(flight.destinations ?? []).filter { airport in airport.name.lowercased().contains(lowerQuery) }.isEmpty
    //        return isNameMatchingQuery || isAnyStatusMatchingQuery || isAnyDestinationMatchingQuery
    //    }
}

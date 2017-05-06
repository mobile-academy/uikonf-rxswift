//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FlightsDisplayable {
    var flights: Variable<[Flight]> { get }
    func flights(filteredBy queryObservable: Observable<String>) -> Observable<[Flight]>
    func refresh() -> Disposable
}

final class FlightsViewModel: FlightsDisplayable {
    private let disposeBag = DisposeBag()
    let schipolCallable: SchipolCallable
    let iataCallable: IATACallable

    let flights: Variable<[Flight]>
    private lazy var flightsCall: Observable<[Flight]> = {
        self.schipolCallable
            .flights()
            .flatMap { flights in self.updateAirports(for: flights) }
            .do(onError: { print($0) })
            .catchErrorJustReturn([])
    }()

    init(schipolCallable: SchipolCallable, iataCallable: IATACallable) {
        self.schipolCallable = schipolCallable
        self.iataCallable = iataCallable
        flights = Variable([])
        flightsCall.bind(to: flights).disposed(by: disposeBag)
    }

    func refresh() -> Disposable {
        return flightsCall.subscribe()
    }

    func flights(filteredBy queryObservable: Observable<String>) -> Observable<[Flight]> {
        return Observable.combineLatest(queryObservable, flights.asObservable()) {
            (query: String, flights: [Flight]) -> [Flight] in
            flights.filter { self.isFlight($0, matching: query) }
        }
    }

    private func isFlight(_ flight: Flight, matching query: String) -> Bool {
        guard !query.isEmpty else { return true }
        let lowerQuery = query.lowercased()
        let isNameMatchingQuery = flight.name.lowercased().contains(lowerQuery)
        let isAnyStatusMatchingQuery = !flight.statuses.filter { status in status.description.lowercased().contains(lowerQuery) }.isEmpty
        let isAnyDestinationMatchingQuery: Bool = !(flight.destinations ?? []).filter { airport in airport.name.lowercased().contains(lowerQuery) }.isEmpty
        return isNameMatchingQuery || isAnyStatusMatchingQuery || isAnyDestinationMatchingQuery
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

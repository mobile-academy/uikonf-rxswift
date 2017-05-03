//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FlightsDisplayable {
    var flights: Variable<[Flight]> { get }
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

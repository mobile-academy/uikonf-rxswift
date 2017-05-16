//
// Created by Maciej Oczko on 03.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Mimus

@testable import RxSwiftWorkshop

final class FakeFlightsViewModel: FlightsDisplayable, Mock {
    private let disposeBag = DisposeBag()

    var storage: [RecordedCall] = []

    let observable: Observable<[Flight]>
    var flights: Variable<[Flight]> = Variable([])

    init(observable: Observable<[Flight]>) {
        self.observable = observable
        observable.bind(to: flights).disposed(by: disposeBag)
    }

    func flights(filteredBy queryObservable: Observable<String>) -> Observable<[Flight]> {
        return Observable.combineLatest(queryObservable, flights.asObservable()) {
            query, flights in
            self.recordCall(withIdentifier: "flightsFilteredBy", arguments: [query])
            return flights
        }
    }

    func refresh() -> Disposable {
        recordCall(withIdentifier: "refresh")
        return observable.subscribe()
    }
}

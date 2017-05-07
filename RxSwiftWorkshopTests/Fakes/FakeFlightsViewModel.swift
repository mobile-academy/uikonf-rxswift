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

    func refresh() -> Disposable {
        recordCall(withIdentifier: "refresh")
        return observable.subscribe()
    }

    func refresh(with filter: FlightsFilter?) -> Disposable {
        recordCall(withIdentifier: "refresh", arguments: [filter])
        return observable.subscribe()
    }
}

extension FlightsFilter: MockEquatable {
    public func equalTo(other: MockEquatable?) -> Bool {
        guard let filter = other as? FlightsFilter else { return false }
        return self == filter
    }
}

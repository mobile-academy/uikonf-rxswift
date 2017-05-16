//
// Created by Krzysztof Siejkowski on 16/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import Mimus
import MapKit

@testable
import RxSwiftWorkshop

final class FakeDirectionsService: DirectionsCallable, Mock {

    enum Identifiers {
        static let directionsFor = "directionsFor"
    }

    var storage: [RecordedCall] = []

    var observable: Observable<MKRoute>?

    func directionsFor(beginning: MKMapItem, end: MKMapItem) -> Observable<MKRoute> {
        recordCall(withIdentifier: Identifiers.directionsFor)
        return observable ?? .empty()
    }
}

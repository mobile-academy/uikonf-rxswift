//
// Created by Krzysztof Siejkowski on 16/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Mimus
import CoreLocation

@testable
import RxSwiftWorkshop

final class FakeLocationManager: LocationStatusRequesting, Mock {

    enum Identifiers {
        static let requestWhenInUseAuthorization = "requestWhenInUseAuthorization"
    }

    var storage: [RecordedCall] = []

    var delegate: CLLocationManagerDelegate? = nil

    func requestWhenInUseAuthorization() {
        recordCall(withIdentifier: Identifiers.requestWhenInUseAuthorization)
    }
}

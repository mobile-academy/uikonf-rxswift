//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import CoreLocation
import Mimus
@testable import RxSwiftWorkshop

final class FakeSystemGeolocator: SystemGeolocator, Mock {

    struct Identifiers {
        static let geocodeAddressString = "geocodeAddressString"
        static let cancelGeocode = "cancelGeocode"
    }

    var storage: [RecordedCall] = []

    func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        recordCall(withIdentifier: Identifiers.geocodeAddressString, arguments: [addressString])
    }

    func cancelGeocode() {
        recordCall(withIdentifier: Identifiers.cancelGeocode)
    }

}
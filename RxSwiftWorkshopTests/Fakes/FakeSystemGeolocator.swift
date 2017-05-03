//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import CoreLocation
import Mimus
import MapKit
@testable import RxSwiftWorkshop

final class FakeSystemGeolocator: SystemGeolocator, Mock {

    private(set) var isGeocoding: Bool = false

    struct Identifiers {
        static let geocodeAddressString = "geocodeAddressString"
        static let cancelGeocode = "cancelGeocode"
    }

    var fixedLocation: CLLocation?
    var fixedError: Error?

    var storage: [RecordedCall] = []

    func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        recordCall(withIdentifier: Identifiers.geocodeAddressString, arguments: [addressString])
        isGeocoding = true
        if let location = fixedLocation {
            completionHandler([MKPlacemark(coordinate: location.coordinate)], nil)
        } else {
            completionHandler(nil, fixedError)
        }
        isGeocoding = false
    }

    func cancelGeocode() {
        recordCall(withIdentifier: Identifiers.cancelGeocode)
        isGeocoding = false
    }

}
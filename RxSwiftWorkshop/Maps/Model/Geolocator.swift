//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

protocol SystemGeolocator {
    func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler)
    func cancelGeocode()
}

extension CLGeocoder: SystemGeolocator {}

// This object performs two tasks:
// * it exposes the reactive API for CLGeocoder
// * it handles the geocoding request limit by serializing the geolocation requests and cancelling on unsubscribe
final class Geolocator {

    private let geolocator: SystemGeolocator

    init(geolocator: SystemGeolocator = CLGeocoder()) {
        self.geolocator = geolocator
    }

    func geolocate(address: String) {
        geolocator.geocodeAddressString(address, completionHandler: { _ in })
    }
}

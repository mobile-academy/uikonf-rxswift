//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

protocol SystemGeolocator {
    var isGeocoding: Bool { get }
    func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler)
    func cancelGeocode()
}

extension CLGeocoder: SystemGeolocator {}

// This object performs two tasks:
// * it exposes the reactive API for CLGeocoder
// * it handles the geocoding request limit by serializing the geolocation requests and cancelling on unsubscribe
final class Geolocator {

    enum Error: Swift.Error {
        case geolocationFailedForUnknownReason
    }

    private let geolocator: SystemGeolocator

    init(geolocator: SystemGeolocator = CLGeocoder()) {
        self.geolocator = geolocator
    }

    func geolocate(address: String) -> Observable<CLLocation> {
        return Observable.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            self.geolocator.geocodeAddressString(address, completionHandler: { maybePlacemark, maybeError in
                if let placemark = maybePlacemark?.first?.location {
                    observer.on(.next(placemark))
                    observer.on(.completed)
                } else if let error = maybeError {
                    observer.on(.error(error))
                } else {
                    observer.on(.error(Error.geolocationFailedForUnknownReason))
                }
            })
            return Disposables.create {
                if self.geolocator.isGeocoding {
                    self.geolocator.cancelGeocode()
                }
            }
        }
    }
}

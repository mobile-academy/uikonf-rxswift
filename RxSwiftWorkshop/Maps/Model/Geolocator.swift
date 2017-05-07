//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

protocol SystemGeolocator {
    var isGeocoding: Bool { get }
    func geocodeAddressString(_ addressString: String, in region: CLRegion?, completionHandler: @escaping CLGeocodeCompletionHandler)
    func cancelGeocode()
}

extension CLGeocoder: SystemGeolocator {}

protocol GeolocationCallable {
    func geolocate(address: String) -> Observable<CLLocation>
}

final class Geolocator: GeolocationCallable {

    enum Error: Swift.Error {
        case geolocationFailedForUnknownReason
    }

    private let geolocator: SystemGeolocator
    private let disposeBag = DisposeBag()
    private var synchronizer: [(Observable<CLLocation>, PublishSubject<CLLocation>)] = []

    init(geolocator: SystemGeolocator = CLGeocoder()) {
        self.geolocator = geolocator
    }

    private let region = CLCircularRegion(
        center: CLLocationCoordinate2D(latitude: 52.310475, longitude: 4.768158),
        radius: CLLocationDistance(100_000),
        identifier: "amsterdam"
    )

    func geolocate(address: String) -> Observable<CLLocation> {
        // TODO: EXERCISE 1: GEOCODER
        // Problem: Write code that transforms the completionBlock-based geolocator API into observable-based API
        // Requirement: There might be only one geolocating request executing at the time. On the end of subscription,
        //              if the request is not finished yet, ensure it's not continuing.
        // HINT 1: You can use `geolocator.isGeocoding` and `geolocator.cancelGeocode()` to ensure request
        //         is not executed when it's not needed.
        // HINT 2: Use `Error.geolocationFailedForUnknownReason` to handle the case when
        //         there's no information what to return.
        // STARTING POINT: Replace the Disposables.create()
        return Observable<CLLocation>.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            if self.geolocator.isGeocoding {
                self.geolocator.cancelGeocode()
            }
            self.geolocator.geocodeAddressString(address, in: self.region, completionHandler: { maybePlacemark, maybeError in
                if let placemark = maybePlacemark?.first?.location {
                    observer.on(.next(placemark))
                    observer.on(.completed)
                } else if let error = maybeError {
                    observer.on(.error(error))
                } else {
                    observer.on(.error(Error.geolocationFailedForUnknownReason))
                }
            })
            return Disposables.create { [weak self] in
                guard let `self` = self else { return }
                if self.geolocator.isGeocoding {
                    self.geolocator.cancelGeocode()
                }
            }
        }
    }
}

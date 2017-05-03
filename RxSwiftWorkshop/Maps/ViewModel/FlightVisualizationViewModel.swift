//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

protocol FlightVisualisation {
    var route: Observable<Route> { get }
    func refresh() -> Disposable
}

final class FlightVisualisationViewModel: FlightVisualisation {

    enum Constants {
        static let amsterdamLocation = CLLocation(latitude: 52.310475, longitude: 4.768158)
    }

    enum Error: Swift.Error {
        case notEnoughInformationToVisualiseFlight
    }

    private let geolocator: Geolocator
    private let geocodingCache: Observable<CLLocation>
    private let flight: Flight
    private let formatter = AirportFormatter()

    private let internalRoute = PublishSubject<Route>()
    var route: Observable<Route> { return internalRoute.asObservable() }

    init(flight: Flight, geolocator: Geolocator) {
        self.flight = flight
        self.geolocator = geolocator
        if let destination = flight.destinations?.first {
            geocodingCache = geolocator
                .geolocate(address: formatter.geolocalizableAddress(from: destination))
                .shareReplay(1)
        } else {
            geocodingCache = .error(Error.notEnoughInformationToVisualiseFlight)
        }
    }

    func refresh() -> Disposable {
        return geocodingCache.flatMap { [weak self] location -> Observable<Route> in
            guard let `self` = self else { return .error(Error.notEnoughInformationToVisualiseFlight) }
            // TODO: should take into consideration whether it's departing or arriving
            // TODO: also, take care of this force unwrap
            return .just(Route(start: Constants.amsterdamLocation, position: self.calculateFlightPosition(forOtherEnd: location), end: location))
        }.do(onNext: { [weak self] in self?.internalRoute.onNext($0) }).subscribe()
    }

    private func calculateFlightPosition(forOtherEnd _: CLLocation) -> CLLocation {
        // TODO: implement
        return Constants.amsterdamLocation
    }
}

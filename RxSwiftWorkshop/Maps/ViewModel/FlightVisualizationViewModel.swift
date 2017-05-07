//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

protocol FlightVisualisation {
    var route: Observable<Route> { get }
}

final class FlightVisualisationViewModel: FlightVisualisation {

    enum Constants {
        static let amsterdamLocation = CLLocation(latitude: 52.310475, longitude: 4.768158)
    }

    enum Error: Swift.Error {
        case notEnoughInformationToVisualiseFlight
    }

    private let geolocator: GeolocationCallable
    private let geocodingCache: Observable<CLLocation>
    private let flight: Flight
    private let formatter = AirportFormatter()

    private let internalRoute = PublishSubject<Route>()
    var route: Observable<Route> {
        return geocodingCache
            .flatMap { [weak self] location -> Observable<Route> in
                guard let `self` = self else {
                    return .error(Error.notEnoughInformationToVisualiseFlight)
                }
                var start: CLLocation?
                var end: CLLocation?
                let isNotArriving = self.flight.statuses.filter({ $0.isArriving }).isEmpty
                let isNotDeparting = self.flight.statuses.filter({ $0.isDeparting }).isEmpty
                if !isNotArriving {
                    start = location
                    end = Constants.amsterdamLocation
                } else if !isNotDeparting {
                    start = Constants.amsterdamLocation
                    end = location
                }
                if let start = start, let end = end {
                    let route = Route(start: start, end: end)
                    return .just(route)
                }
                return .empty()
            }
    }

    init(flight: Flight, geolocator: GeolocationCallable) {
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
}

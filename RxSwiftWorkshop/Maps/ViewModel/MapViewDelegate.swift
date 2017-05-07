//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import CoreLocation

protocol UserLocationProviding {
    var userLocation: Observable<MapViewDelegate.UserLocation> { get }
}

final class MapViewDelegate: NSObject, UserLocationProviding, MKMapViewDelegate, CLLocationManagerDelegate {

    private let locationManager: CLLocationManager

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }

    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer(overlay: overlay) }
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = .blue
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }

    enum UserLocation {
        case possible
        case forbidden
        case update(MKUserLocation)
        case failed(Error)
    }

    // TODO: EXERCISE 2: DELEGATE
    // Problem: Write code that exposes the events from MKMapViewDelegate and CLLocationManagerDelegate
    //          as Observable<UserLocation>.
    // Requirement: You should ensure that the CLLocationManager is authorized when trying to read user location
    //              and report the authorization result, as well as the user location update success / failure.
    //              UserLocation enum is specifying all the cases you need to cover.
    // HINT 1: Use `PublishSubject` as a receiver of events from delegates and broadcaster of those event to the world
    // HINT 2: You can take advantage of the fact that `userLocation: Observable<UserLocation>` is a computed property
    //         adn therefore can contain additional logic, like the authorization handling.
    // STARTING POINTS: replace the `.empty()` and fill in the bodies of three empty delegate methods.

    var userLocation: Observable<UserLocation> {
        return .empty()
    }

    public func locationManager(_: CLLocationManager, didChangeAuthorization _: CLAuthorizationStatus) {
    }

    public func mapView(_: MKMapView, didUpdate _: MKUserLocation) {
    }

    public func mapView(_: MKMapView, didFailToLocateUserWithError _: Error) {
    }
}

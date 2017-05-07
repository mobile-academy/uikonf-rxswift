//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import RxSwift
import CoreLocation

final class MapViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let delegate: MapViewDelegate
    private let flightsViewModel: FlightVisualisationViewModel
    private let routeViewModel: AlternativeRouteVisualisationViewModel
    private let mapView: MKMapView
    private var destination: CLLocationCoordinate2D?

    init(
        flightsViewModel: FlightVisualisationViewModel,
        routeViewModel: AlternativeRouteVisualisationViewModel,
        delegate: MapViewDelegate
    ) {
        self.delegate = delegate
        self.flightsViewModel = flightsViewModel
        self.routeViewModel = routeViewModel
        mapView = MKMapView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        setupMapView()
    }

    required init?(coder _: NSCoder) {
        fatalError("😇")
    }

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        flightsViewModel.route.subscribe(onNext: { [unowned self] route in
            self.showFlightRoute(route: route)
        }).disposed(by: disposeBag)
        routeViewModel.route.subscribe(onNext: { [unowned self] result in
            switch result {
            case let .success(route): self.showUserRoute(route: route)
            case .failure: break // error handling
            }
        }).disposed(by: disposeBag)
    }

    func setupMapView() {
        mapView.delegate = delegate
        delegate.userLocation
            .subscribe(onNext: { [unowned self] userLocation in
                switch userLocation {
                case .possible:
                    self.mapView.showsUserLocation = true
                case let .update(location):
                    if let destination = self.destination {
                        self.routeViewModel
                            .refreshFor(start: location.coordinate, end: destination)
                            .disposed(by: self.disposeBag)
                    }
                default: break
                }
            }).disposed(by: disposeBag)
    }

    func showFlightRoute(route: Route) {
        destination = route.end.coordinate
        let coordinates = [route.start, route.end].map { $0.coordinate }
        coordinates.withUnsafeBufferPointer { pointer in
            guard let unsafePointer = pointer.baseAddress else { return }
            let polyline = MKPolyline(coordinates: unsafePointer, count: pointer.count)
            self.mapView.add(polyline, level: .aboveLabels)
        }
        mapView.setCenter(route.end.coordinate, animated: true)
    }

    func showUserRoute(route: MKRoute) {
        mapView.add(route.polyline, level: .aboveRoads)
    }
}

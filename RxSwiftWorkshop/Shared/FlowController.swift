//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit

final class FlowController {

    func setupRootViewController(for window: UIWindow) {
        window.rootViewController = createFlightsViewController()
    }

    private func createFlightsViewController() -> UIViewController {
        let jsonClient = JSONAPIClient()
        let schipolService = SchipolService(client: jsonClient)
        let iataService = IATAService(client: jsonClient)
        let flightViewModel = FlightsViewModel(schipolCallable: schipolService, iataCallable: iataService)
        let flightsViewController = FlightsViewController(viewModel: flightViewModel, showDetailsViewController: showMapViewController)
        return UINavigationController(rootViewController: flightsViewController)
    }

    func showMapViewController(flight: Flight, from fromViewController: UIViewController) {
        let geolocator = Geolocator()
        let flightVisualisationViewModel = FlightVisualisationViewModel(flight: flight, geolocator: geolocator)
        let directionsService = DirectionsService()
        let routeVisualisationViewModel = AlternativeRouteVisualisationViewModel(directionsService: directionsService)
        let delegate = MapViewDelegate()
        let mapViewController = MapViewController(
            flightsViewModel: flightVisualisationViewModel,
            routeViewModel: routeVisualisationViewModel,
            delegate: delegate
        )
        fromViewController.navigationController?.pushViewController(mapViewController, animated: true)
    }
}

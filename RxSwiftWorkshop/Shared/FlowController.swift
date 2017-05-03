//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit

final class FlowController {

    func provideRootViewController() -> UIViewController {
        let jsonClient = JSONAPIClient()
        let schipolService = SchipolService(client: jsonClient)
        let iataService = IATAService(client: jsonClient)
        let flightViewModel = FlightsViewModel(schipolCallable: schipolService, iataCallable: iataService)
        let flightsViewController = FlightsViewController(viewModel: flightViewModel, detailsViewControllerCreator: provideMapViewController)
        let navigationController = UINavigationController(rootViewController: flightsViewController)
        return navigationController
    }

    func provideMapViewController(flight: Flight) -> UIViewController {
        let geolocator = Geolocator()
        let flightVisualisationViewModel = FlightVisualisationViewModel(flight: flight, geolocator: geolocator)
        let delegate = MapViewDelegate()
        return MapViewController(viewModel: flightVisualisationViewModel, delegate: delegate)
    }
}

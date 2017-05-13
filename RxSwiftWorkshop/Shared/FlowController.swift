//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class FlowController {

    func setupRootViewController(for window: UIWindow) {
        window.rootViewController = createFlightsViewController()
    }

    private func createFlightsViewController() -> UIViewController {
        let jsonClient = JSONAPIClient()
        let schipolService = SchipolService(client: jsonClient)
        let iataService = IATAService(client: jsonClient)
        let flightViewModel = FlightsViewModel(schipolCallable: schipolService, iataCallable: iataService)
        let flightsViewController = FlightsViewController(
            viewModel: flightViewModel,
            showDetailsViewController: showMapViewController,
            showFilterViewController: showFlightsFilterViewController
        )
        return UINavigationController(rootViewController: flightsViewController)
    }

    func showMapViewController(flight: Flight, from fromViewController: UIViewController) {
        let geolocator = Geolocator()
        let flightVisualisationViewModel = FlightVisualisationViewModel(flight: flight, geolocator: geolocator)
        let delegate = MapViewDelegate()
        let mapViewController = MapViewController(viewModel: flightVisualisationViewModel, delegate: delegate)
        fromViewController.navigationController?.pushViewController(mapViewController, animated: true)
    }

    func showFlightsFilterViewController(parent: UIViewController, filterChange: @escaping FilterChangeCallback) {
        let flightsFilterViewController = FlightsFilterViewController(filterChange: filterChange, dismissViewController: {
            parent.dismiss(animated: true)
        })
        let navigationController = UINavigationController(rootViewController: flightsFilterViewController)
        parent.present(navigationController, animated: true)
    }
}

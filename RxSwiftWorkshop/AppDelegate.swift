//
//  AppDelegate.swift
//  RxSwiftWorkshop
//
//  Created by Paweł Dudek on 22/04/2017.
//  Copyright © 2017 Mobile Academy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard !isRunningUnitTests() else { return false }

        window = UIWindow(frame: UIScreen.main.bounds)

        let jsonClient = JSONAPIClient()
        let schipolService = SchipolService(client: jsonClient)
        let iataService = IATAService(client: jsonClient)
        let flightViewModel = FlightsViewModel(schipolCallable: schipolService, iataCallable: iataService)
        let flightsViewController = FlightsViewController(viewModel: flightViewModel)
        let navigationController = UINavigationController(rootViewController: flightsViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

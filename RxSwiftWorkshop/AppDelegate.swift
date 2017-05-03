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

    private var keyWindow: UIWindow?
    private let flowController = FlowController()

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard !isRunningUnitTests() else { return false }
        let window = UIWindow(frame: UIScreen.main.bounds)
        flowController.setupRootViewController(for: window)
        window.makeKeyAndVisible()
        keyWindow = window
        return true
    }
}

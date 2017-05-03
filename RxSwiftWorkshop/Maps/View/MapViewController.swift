//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

final class MapViewController: UIViewController {

    private let delegate = MapViewDelegate()

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder _: NSCoder) {
        fatalError("😇")
    }

    override func loadView() {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = delegate
        view = mapView
    }
}

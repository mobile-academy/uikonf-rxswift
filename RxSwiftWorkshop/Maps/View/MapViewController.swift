//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import RxSwift

final class MapViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let delegate: MapViewDelegate
    private let viewModel: FlightVisualisationViewModel
    private let mapView: MKMapView

    init(viewModel: FlightVisualisationViewModel, delegate: MapViewDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        mapView = MKMapView(frame: .zero)
        mapView.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("😇")
    }

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.route.subscribe(onNext: { [unowned self] route in
            let coordinates = [route.start, route.end].map { $0.coordinate }
            coordinates.withUnsafeBufferPointer { pointer in
                guard let unsafePointer = pointer.baseAddress else { return }
                var polyline = MKPolyline(coordinates: unsafePointer, count: pointer.count)
                self.mapView.add(polyline, level: .aboveLabels)
            }
            self.mapView.setCenter(route.position.coordinate, animated: true)
        }).disposed(by: disposeBag)
    }
}

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

    init(viewModel: FlightVisualisationViewModel, delegate: MapViewDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("😇")
    }

    override func loadView() {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = delegate
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.route.subscribe(onNext: { route in
            print(route)
        }).disposed(by: disposeBag)
        viewModel.refresh()
    }
}

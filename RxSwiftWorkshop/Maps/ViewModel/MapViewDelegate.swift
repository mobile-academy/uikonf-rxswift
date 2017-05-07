//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import MapKit

final class MapViewDelegate: NSObject, MKMapViewDelegate {

    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer(overlay: overlay) }
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = .blue
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
}

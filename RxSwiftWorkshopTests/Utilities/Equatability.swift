//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import RxSwift
@testable
import RxSwiftWorkshop

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MapViewDelegate.UserLocation: Equatable {
    public static func ==(lhs: MapViewDelegate.UserLocation, rhs: MapViewDelegate.UserLocation) -> Bool {
        switch (lhs, rhs) {
        case (.possible, .possible), (.forbidden, .forbidden): return true
        case let (.update(lhsLocation), .update(rhsLocation)): return lhsLocation == rhsLocation
        case (.failed(_), .failed(_)): return true //untyped
        default: return false
        }
    }
}

extension Event {
    var isCompleted: Bool {
        if case .completed = self {
            return true
        }
        return  false
    }
    var isError: Bool {
        if case .error = self {
            return true
        }
        return  false
    }
}

//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
//
// Created by Maciej Oczko on 07.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation

struct FlightsFilter: SchipolQueryContext {
    let fromDate: String?
    let toDate: String?
}

extension FlightsFilter: Equatable {}

func ==(lhs: FlightsFilter, rhs: FlightsFilter) -> Bool {
    return lhs.fromDate == rhs.fromDate
        && lhs.toDate == rhs.toDate
}

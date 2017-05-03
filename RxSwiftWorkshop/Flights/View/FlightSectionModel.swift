//
// Created by Maciej Oczko on 03.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxDataSources

struct FlightSectionModel {
    var items: [Flight]
}

extension FlightSectionModel: AnimatableSectionModelType {
    typealias Item = Flight

    var identity: Int {
        return items.reduce(0) { result, item in result ^ item.id }
    }

    init(original: FlightSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

extension Flight: IdentifiableType {
    var identity: Int {
        return id
    }
}

//
// Created by Maciej Oczko on 07.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation

protocol SchipolQueryContext {
    var fromDate: String? { get }
    var toDate: String? { get }
}

extension SchipolQueryContext {
    func queryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let fromDate = fromDate {
            items.append(URLQueryItem(name: "fromdate", value: fromDate))
        }
        if let toDate = toDate {
            items.append(URLQueryItem(name: "todate", value: toDate))
        }
        return items
    }
}

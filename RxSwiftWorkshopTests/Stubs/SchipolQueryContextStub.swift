//
// Created by Maciej Oczko on 07.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation

@testable import RxSwiftWorkshop

struct SchipolQueryContextStub: SchipolQueryContext {
    var fromDate: String? = "2017-01-01"
    var toDate: String? = "2017-06-06"
}

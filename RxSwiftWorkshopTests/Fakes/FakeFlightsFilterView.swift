//
// Created by Maciej Oczko on 14.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

@testable import RxSwiftWorkshop

final class FakeFlightsFilterView: UIView, FlightsFilterViewType {
    var fromDateStringObservable: Observable<String?> = .empty()
    var toDateStringObservable: Observable<String?> = .empty()

    init() {
        super.init(frame: .zero)
    }

    required init?(coder _: NSCoder) {
        fatalError("😢")
    }
}

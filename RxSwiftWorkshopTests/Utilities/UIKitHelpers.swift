//
// Created by Maciej Oczko on 14.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

@testable import RxCocoa

extension UIBarButtonItem {

    func simulateTap() {
        if let target = target as? BarButtonItemTarget {
            target.callback()
        }
    }
}

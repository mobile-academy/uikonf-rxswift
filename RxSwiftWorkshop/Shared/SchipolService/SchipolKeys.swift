//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Keys

protocol SchipolKeys {
    var schipholAPIAppID: String { get }
    var schipholAPIAppKey: String { get }
}

extension RxSwiftWorkshopKeys: SchipolKeys {}

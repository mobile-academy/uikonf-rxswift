//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Keys

protocol IATAKeys {
	var iATACodesAPIKey: String { get }
}

extension RxSwiftWorkshopKeys: IATAKeys { }

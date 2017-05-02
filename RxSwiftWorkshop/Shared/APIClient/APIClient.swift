//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift

typealias ResponseJSON = [String: Any]

protocol APIClient {
	func call(request: URLRequest) -> Observable<ResponseJSON>
}

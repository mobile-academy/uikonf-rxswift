//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxTest

@testable import RxSwiftWorkshop

final class FakeSchipolService: SchipolCallable {
	var observable: Observable<[Flight]>!

	func flights() -> Observable<[Flight]> {
		return observable
	}

	func flights(with context: SchipolQueryContext?) -> Observable<[Flight]> {
		return observable
	}
}

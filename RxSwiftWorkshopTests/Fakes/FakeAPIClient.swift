//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxTest
import Mimus

@testable import RxSwiftWorkshop

final class FakeAPIClient: APIClient, Mock {
	var observable: Observable<ResponseJSON>!

	var storage: [RecordedCall] = []

	func call(request: URLRequest) -> Observable<ResponseJSON> {
		recordCall(withIdentifier: "call", arguments: [request])
		return observable
	}
}

extension URLRequest: MockEquatable {
	public func equalTo(other: MockEquatable?) -> Bool {
		if let otherRequest = other as? URLRequest {
			return url == otherRequest.url && httpMethod == otherRequest.httpMethod
		}
		return false
	}
}

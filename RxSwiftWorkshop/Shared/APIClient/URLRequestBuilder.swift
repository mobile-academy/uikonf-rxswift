//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift

struct URLRequestBuilder {
	enum Error: Swift.Error {
		case malformedURL(message: String)
	}

	let base: URL

	func build(for path: String, with queryItems: [URLQueryItem] = []) -> Single<URLRequest> {
		var urlComponents = URLComponents(url: self.base.appendingPathComponent(path), resolvingAgainstBaseURL: false)
		if !queryItems.isEmpty {
			urlComponents?.queryItems = queryItems
		}
		guard let url = urlComponents?.url else {
			return .error(Error.malformedURL(message: "Cannot compose url for \(path)."))
		}
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		return .just(request)
	}
}

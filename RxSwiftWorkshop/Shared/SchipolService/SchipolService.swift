//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import Marshal
import Keys

protocol SchipolCallable {
	func flights() -> Observable<[Flight]>
}

struct SchipolService: SchipolCallable {
	struct Constants {
		static let baseURL = "https://api.schiphol.nl/public-flights/"
	}

	let client: APIClient
	let keys: SchipolKeys
	private let requestBuilder: URLRequestBuilder

	init(client: APIClient = JSONAPIClient(), keys: SchipolKeys = RxSwiftWorkshopKeys()) {
		self.client = client
		self.keys = keys
		guard let url = URL(string: Constants.baseURL) else { fatalError("Cannot parse Schipol base url.") }
		self.requestBuilder = URLRequestBuilder(base: url)
	}

	func flights() -> Observable<[Flight]> {
		return requestBuilder
				.build(for: "flights", with: queryParameters()).asObservable()
				.flatMap(client.call)
				.map { json -> [Flight] in try json.value(for: "flights") }
	}

	private func queryParameters() -> [URLQueryItem] {
		return [
				URLQueryItem(name: "app_id", value: keys.schipholAPIAppID),
				URLQueryItem(name: "app_key", value: keys.schipholAPIAppKey)
		]
	}
}

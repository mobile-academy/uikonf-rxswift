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
        static let baseURL: URL = {
            let urlString = "https://api.schiphol.nl/public-flights/"
            guard let url = URL(string: urlString) else { fatalError("Cannot parse Schipol base url.") }
            return url
        }()
    }

    let client: APIClient
    let keys: SchipolKeys
    private let requestBuilder: URLRequestBuilder

    init(client: APIClient, keys: SchipolKeys = RxSwiftWorkshopKeys()) {
        self.client = client
        self.keys = keys
        requestBuilder = URLRequestBuilder(base: Constants.baseURL)
    }

    func flights() -> Observable<[Flight]> {
        return requestBuilder
            .build(for: "flights", with: queryParameters(), headers: headers()).asObservable()
            .flatMap(client.call)
            .map { json -> [Flight] in try json.value(for: "flights") }
    }

    private func queryParameters() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "app_id", value: keys.schipholAPIAppID),
            URLQueryItem(name: "app_key", value: keys.schipholAPIAppKey),
        ]
    }

    private func headers() -> [String: String] {
        return [
            "ResourceVersion": "v3",
        ]
    }
}

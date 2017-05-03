//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import Marshal
import Keys

protocol IATACallable {
    func airport(for code: String) -> Observable<Airport>
    func airline(for code: String) -> Observable<Airline>
}

struct IATAService: IATACallable {
    struct Constants {
        static let baseURL: URL = {
            let urlString = "http://iatacodes.org/api/v6/"
            guard let url = URL(string: urlString) else { fatalError("Cannot parse IATA base url.") }
            return url
        }()
    }

    let client: APIClient
    let keys: IATAKeys
    private let requestBuilder: URLRequestBuilder

    init(client: APIClient, keys: IATAKeys = RxSwiftWorkshopKeys()) {
        self.client = client
        self.keys = keys
        requestBuilder = URLRequestBuilder(base: Constants.baseURL)
    }

    func airport(for code: String) -> Observable<Airport> {
        return serviceCall(for: "airports", with: code)
    }

    func airline(for code: String) -> Observable<Airline> {
        return serviceCall(for: "airlines", with: code)
    }

    private func serviceCall<T: Unmarshaling>(for path: String, with code: String) -> Observable<T> {
        return requestBuilder
            .build(for: path, with: queryParameters(with: code)).asObservable()
            .flatMap(client.call)
            .map { json -> [T] in try json.value(for: "response") }
            .map { items -> T in items.first! }
    }

    private func queryParameters(with code: String) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "api_key", value: keys.iATACodesAPIKey),
            URLQueryItem(name: "code", value: code),
        ]
    }
}

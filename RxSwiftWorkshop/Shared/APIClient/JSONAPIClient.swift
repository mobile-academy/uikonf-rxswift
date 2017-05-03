//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class JSONAPIClient: APIClient {
    enum Error: Swift.Error {
        case conversionFailed(message: String)
    }

    let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func call(request: URLRequest) -> Observable<ResponseJSON> {
        return urlSession.rx.json(request: request).map {
            value in
            guard let json = value as? ResponseJSON else {
                throw RxCocoaURLError.deserializationError(error: Error.conversionFailed(message: "Can't convert response type to ResponseJSON"))
            }
            return json
        }
    }
}

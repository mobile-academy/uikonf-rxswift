import Foundation
import RxSwift
import MapKit

protocol DirectionsCallable {
    func directionsFor(beginning: MKMapItem, end: MKMapItem) -> Observable<MKRoute>
}

final class DirectionsService: DirectionsCallable {

    enum Error: Swift.Error {
        case unknownDirectionsAPIError
    }

    func directionsFor(beginning: MKMapItem, end: MKMapItem) -> Observable<MKRoute> {
        return Observable.create { observer in
            let request = MKDirectionsRequest()
            request.source = beginning
            request.destination = end
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let error = error {
                    observer.onError(error)
                } else if let response = response,
                    let route = response.routes.first {
                    observer.onNext(route)
                } else {
                    observer.onError(Error.unknownDirectionsAPIError)
                }
            }
            return Disposables.create {
                if directions.isCalculating {
                    directions.cancel()
                }
            }
        }
    }
}

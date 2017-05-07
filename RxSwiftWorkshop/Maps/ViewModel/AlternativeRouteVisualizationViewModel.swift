import Foundation
import MapKit
import RxSwift
import Result
import CoreLocation

enum AlternativeRouteVisualisationError: Swift.Error {
    case withInternal(Error)
}

protocol AlternativeRouteVisualisation {
    var route: Observable<Result<MKRoute, AlternativeRouteVisualisationError>> { get }
    func refreshFor(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Disposable
}

final class AlternativeRouteVisualisationViewModel: AlternativeRouteVisualisation {

    private let disposeBag = DisposeBag()
    private let directionsService: DirectionsCallable

    init(directionsService: DirectionsCallable) {
        self.directionsService = directionsService
    }

    // TODO: EXERCISE 3: PASSING ERRORS THROUGH SUBJECTS
    // Problem: Write code that let you refresh the direcions for locations, but also let you handle possible errors.
    // Requirement: Use the Result type (provided from antitypical/Result micro-framework) to prevent the errors from
    //              closing the subscription and at the same time pass the proper values further.
    // STARTING POINTS: replace the `.empty()` and fill in the bodies of the empty `refreshFor` method.

    private let routeSubject = PublishSubject<Result<MKRoute, AlternativeRouteVisualisationError>>()

    var route: Observable<Result<MKRoute, AlternativeRouteVisualisationError>> {
        return routeSubject.asObservable()
    }

    func refreshFor(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Disposable {
        let beginning = MKMapItem(placemark: MKPlacemark(coordinate: start))
        let finish = MKMapItem(placemark: MKPlacemark(coordinate: end))
        return directionsService.directionsFor(beginning: beginning, end: finish)
            .subscribe(onNext: { [weak self] route in
                self?.routeSubject.onNext(.success(route))
            }, onError: { [weak self] error in
                self?.routeSubject.onNext(.failure(.withInternal(error)))
            })
    }
}

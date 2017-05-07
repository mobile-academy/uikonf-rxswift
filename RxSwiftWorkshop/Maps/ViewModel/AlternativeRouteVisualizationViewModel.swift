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
    private let directionsService: DirectionsService

    init(directionsService: DirectionsService) {
        self.directionsService = directionsService
    }

    // TODO: EXERCISE 3: PASSING ERRORS THROUGH SUBJECTS
    // Problem: Write code that let you refresh the direcions for locations, but also let you handle possible errors.
    // Requirement: Use the Result type (provided from antitypical/Result micro-framework) to prevent the errors from
    //              closing the subscription and at the same time pass the proper values further.
    // STARTING POINTS: replace the `.empty()` and fill in the bodies of the empty `refreshFor` method.

    var route: Observable<Result<MKRoute, AlternativeRouteVisualisationError>> {
        return .empty()
    }

    func refreshFor(start _: CLLocationCoordinate2D, end _: CLLocationCoordinate2D) -> Disposable {
        return Disposables.create()
    }
}

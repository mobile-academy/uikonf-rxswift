//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import MapKit
import CoreLocation
import Result
import RxTest

@testable
import RxSwiftWorkshop

final class AlternativeRouteVisualizationViewModelSpec: QuickSpec {
    override func spec() {
        describe("AlternativeRouteVisualizationViewModel") {

            var disposeBag: DisposeBag?
            var directionsService: FakeDirectionsService?
            var sut: AlternativeRouteVisualisationViewModel?
            var scheduler: TestScheduler?

            let route = MKRoute()
            let start = CLLocationCoordinate2D(latitude: 123.4, longitude: 142.3)
            let end = CLLocationCoordinate2D(latitude: 12.3, longitude: 14.3)

            beforeEach {
                disposeBag = DisposeBag()
                let fakeDirectionsService = FakeDirectionsService()
                directionsService = fakeDirectionsService
                scheduler = TestScheduler(initialClock: 0)
                sut = AlternativeRouteVisualisationViewModel(directionsService: fakeDirectionsService)
            }

            afterEach {
                disposeBag = nil
                directionsService = nil
                sut = nil
            }

            context("always") {
                setup {
                    guard let (sut, disposeBag) = unwrap(sut, disposeBag) else { return }
                    sut.refreshFor(start: start, end: end).disposed(by: disposeBag)
                }
                it("should pass directions request to its DirectionsService") {
                    guard let directionsService = unwrap(directionsService) else { return }
                    directionsService.verifyCall(withIdentifier: FakeDirectionsService.Identifiers.directionsFor)
                }
            }

            context("when DirectionsService succeeds in finding directions") {
                var observer: TestableObserver<Result<MKRoute, AlternativeRouteVisualisationError>>?
                setup {
                    guard let (sut, disposeBag, directionsService, scheduler) = unwrap(sut, disposeBag, directionsService, scheduler) else { return }
                    directionsService.observable = scheduler.createColdObservable([next(1, route), completed(1)]).asObservable()
                    sut.refreshFor(start: start, end: end).disposed(by: disposeBag)
                    observer = scheduler.start(created: 0, subscribed: 0, disposed: 2, create: { sut.route })
                }
                it("should return directions") {
                    let element: Result<MKRoute, AlternativeRouteVisualisationError>? = observer?.events.first?.value.element
                    guard case let .success(returnedRoute)? = unwrap(element) else { return }
                    expect(returnedRoute).to(beIdenticalTo(route))
                }
                it("should not finish the subscription") {
                    guard let event = unwrap(observer?.events.last?.value) else { return }
                    expect(event.isCompleted).to(beFalse())
                }
            }

            context("when DirectionsService fails in finding directions") {
                var observer: TestableObserver<Result<MKRoute, AlternativeRouteVisualisationError>>?
                setup {
                    guard let (sut, disposeBag, directionsService, scheduler) = unwrap(sut, disposeBag, directionsService, scheduler) else { return }
                    directionsService.observable = scheduler.createColdObservable([error(1, DirectionsService.Error.unknownDirectionsAPIError), completed(1)]).asObservable()
                    sut.refreshFor(start: start, end: end).disposed(by: disposeBag)
                    observer = scheduler.start(created: 0, subscribed: 0, disposed: 2, create: { sut.route })
                }
                it("should return the DirectionsService error") {
                    let element: Result<MKRoute, AlternativeRouteVisualisationError>? = observer?.events.first?.value.element
                    guard case let .failure(AlternativeRouteVisualisationError.withInternal(error))? = unwrap(element) else { return }
                    expect(error as? DirectionsService.Error).to(equal(DirectionsService.Error.unknownDirectionsAPIError))
                }
                it("should not error out the subscription") {
                    guard let event = unwrap(observer?.events.last?.value) else { return }
                    expect(event.isError).to(beFalse())
                }
            }
        }
    }
}

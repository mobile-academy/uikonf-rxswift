//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import RxTest
import Nimble
import RxSwift
import CoreLocation
import MapKit

@testable
import RxSwiftWorkshop

class MapViewDelegateSpec: QuickSpec {
    override func spec() {
        describe("MapViewDelegate") {

            var disposeBag: DisposeBag?
            var sut: MapViewDelegate?
            var observer: TestableObserver<MapViewDelegate.UserLocation>?
            var locationManager: FakeLocationManager?

            beforeEach {
                disposeBag = DisposeBag()
                let fakeLocationManager = FakeLocationManager()
                locationManager = fakeLocationManager
                sut = MapViewDelegate(locationManager: fakeLocationManager, authorizationStatusCheck: { CLAuthorizationStatus.notDetermined })
                let testScheduler = TestScheduler(initialClock: 0)
                observer = testScheduler.createObserver(MapViewDelegate.UserLocation.self)
                guard let (sut, disposeBag, observer) = unwrap(sut, disposeBag, observer) else { return }
                sut.userLocation.subscribe(observer).disposed(by: disposeBag)
            }

            afterEach {
                disposeBag = nil
                sut = nil
                observer = nil
            }

            context("when location update succeeds") {
                let userLocation = MKUserLocation()
                setup {
                    guard let sut = unwrap(sut) else { return }
                    sut.mapView(MKMapView(), didUpdate: userLocation)
                }
                it("should propagate this as an UserLocation event") {
                    guard case let MapViewDelegate.UserLocation.update(location)? = unwrap(observer?.events.first?.value.element) else { return }
                    expect(location).to(equal(userLocation))
                }
            }

            context("when location update failes") {
                enum Error: Swift.Error { case userLocationFailed }
                let error = Error.userLocationFailed
                setup {
                    guard let sut = unwrap(sut) else { return }
                    sut.mapView(MKMapView(), didFailToLocateUserWithError: error)
                }
                it("should propagate this as an UserLocation event") {
                    guard case let MapViewDelegate.UserLocation.failed(obtainedError)? = unwrap(observer?.events.first?.value.element),
                        let typedError = obtainedError as? Error
                    else { return }
                    expect(typedError).to(equal(error))
                }
            }

            context("when location authorization status changes to authorizedAlways") {
                setup {
                    guard let sut = unwrap(sut) else { return }
                    sut.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedAlways)
                }
                it("should propagate this as an UserLocation event") {
                    guard let userLocation = unwrap(observer?.events.first?.value.element) else { return }
                    expect(userLocation).to(equal(MapViewDelegate.UserLocation.possible))
                }
            }

            context("when location authorization status changes to authorizedWhenInUse") {
                setup {
                    guard let sut = unwrap(sut) else { return }
                    sut.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedWhenInUse)
                }
                it("should propagate this as an UserLocation event") {
                    guard let userLocation = unwrap(observer?.events.first?.value.element) else { return }
                    expect(userLocation).to(equal(MapViewDelegate.UserLocation.possible))
                }
            }

            context("when location authorization status changes to restricted") {
                setup {
                    guard let sut = unwrap(sut) else { return }
                    sut.locationManager(CLLocationManager(), didChangeAuthorization: .restricted)
                }
                it("should propagate this as an UserLocation event") {
                    guard let userLocation = unwrap(observer?.events.first?.value.element) else { return }
                    expect(userLocation).to(equal(MapViewDelegate.UserLocation.forbidden))
                }
            }

            context("when location authorization status changes to denied") {
                setup {
                    guard let sut = unwrap(sut) else { return }
                    sut.locationManager(CLLocationManager(), didChangeAuthorization: .denied)
                }
                it("should propagate this as an UserLocation event") {
                    guard let userLocation = unwrap(observer?.events.first?.value.element) else { return }
                    expect(userLocation).to(equal(MapViewDelegate.UserLocation.forbidden))
                }
            }

            context("if the location is not determined yet") {
                it("should request authorization on subscription") {
                    guard let locationManager = unwrap(locationManager) else { return }
                    locationManager.verifyCall(withIdentifier: FakeLocationManager.Identifiers.requestWhenInUseAuthorization)
                }
            }

            context("always") {
                it("should set itself as a delegate to location providing") {
                    guard let (sut, locationManager) = unwrap(sut, locationManager) else { return }
                    expect(sut).to(beIdenticalTo(locationManager.delegate))
                }
            }
        }
    }
}

//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import CoreLocation

@testable
import RxSwiftWorkshop

class GeolocatorSpec: QuickSpec {

    override func spec() {
        describe("Geolocator") {

            var disposeBag: DisposeBag?
            var systemGeolocator: FakeSystemGeolocator?
            var sut: Geolocator?

            beforeEach {
                disposeBag = DisposeBag()
                let geolocator = FakeSystemGeolocator()
                systemGeolocator = geolocator
                sut = Geolocator(geolocator: geolocator)
            }

            afterEach {
                disposeBag = nil
                systemGeolocator = nil
                sut = nil
            }

            it("should pass geolocation request to its SystemGeolocator") {
                guard case let (disposeBag?, systemGeolocator?) = unwrap(disposeBag, systemGeolocator) else { return }
                let address = "Valencia Airport"
                sut?.geolocate(address: address).subscribe().disposed(by: disposeBag)
                systemGeolocator.verifyCall(
                    withIdentifier: FakeSystemGeolocator.Identifiers.geocodeAddressString, arguments: [address]
                )
            }

            it("should return geolocation from its SystemGeolocator") {
                guard case let (sut?, disposeBag?, systemGeolocator?) = unwrap(sut, disposeBag, systemGeolocator) else { return }
                let location = CLLocation(latitude: 123.123, longitude: 132.132)
                systemGeolocator.fixedLocation = location
                var result: CLLocation?
                sut.geolocate(address: "Valencia Airport").subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
                expect(result?.coordinate).to(equal(location.coordinate))
            }

            it("should return error from its SystemGeolocator") {
                enum Error: Swift.Error { case someError }
                guard case let (sut?, disposeBag?, systemGeolocator?) = unwrap(sut, disposeBag, systemGeolocator) else { return }
                let location = CLLocation(latitude: 123.123, longitude: 132.132)
                systemGeolocator.fixedError = Error.someError
                var result: Error?
                sut.geolocate(address: "Valencia Airport").subscribe(onError: { result = $0 as? Error }).disposed(by: disposeBag)
                expect(result).to(equal(Error.someError))
            }

            it("should return proper error from its SystemGeolocator when it acts broken") {
                guard case let (sut?, disposeBag?) = unwrap(sut, disposeBag) else { return }
                let location = CLLocation(latitude: 123.123, longitude: 132.132)
                var result: Geolocator.Error?
                sut.geolocate(address: "Valencia Airport").subscribe(onError: { result = $0 as? Geolocator.Error }).disposed(by: disposeBag)
                expect(result).to(equal(Geolocator.Error.geolocationFailedForUnknownReason))
            }

            it("should cancel geocoding on subscription disposing") {
                guard case let (sut?, systemGeolocator?) = unwrap(sut, systemGeolocator) else { return }
                systemGeolocator.shouldReturnAtAll = false
                expect(systemGeolocator.isGeocoding).to(beFalse())
                let disposable = sut.geolocate(address: "Valencia Airport").subscribe()
                expect(systemGeolocator.isGeocoding).to(beTrue())
                disposable.dispose()
                expect(systemGeolocator.isGeocoding).to(beFalse())
            }
        }
    }
}

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

            context("always") {
                let address = "Valencia Airport"
                setup {
                    guard let (sut, disposeBag) = unwrap(sut, disposeBag) else { return }
                    sut.geolocate(address: address).subscribe().disposed(by: disposeBag)
                }
                it("should pass geolocation request to its SystemGeolocator") {
                    guard let systemGeolocator = unwrap(systemGeolocator) else { return }
                    systemGeolocator.verifyCall(
                        withIdentifier: FakeSystemGeolocator.Identifiers.geocodeAddressString, arguments: [address]
                    )
                }
            }

            context("when SystemGeolocator succeeds in finding location") {
                let location = CLLocation(latitude: 123.123, longitude: 132.132)
                var result: CLLocation?
                setup {
                    guard let (systemGeolocator, sut, disposeBag) = unwrap(systemGeolocator, sut, disposeBag) else { return }
                    systemGeolocator.fixedLocation = location
                    sut.geolocate(address: "Valencia Airport")
                        .subscribe(onNext: { result = $0 })
                        .disposed(by: disposeBag)
                }
                it("should return this location") {
                    guard let result = unwrap(result) else { return }
                    expect(result.coordinate).to(equal(location.coordinate))
                }
            }

            context("when SystemGeolocator fails in finding location") {
                enum Error: Swift.Error { case someError }
                var result: Error?
                setup {
                    guard let (systemGeolocator, sut, disposeBag) = unwrap(systemGeolocator, sut, disposeBag) else { return }
                    systemGeolocator.fixedError = Error.someError
                    sut.geolocate(address: "Valencia Airport")
                        .subscribe(onError: { result = $0 as? Error })
                        .disposed(by: disposeBag)
                }
                it("should return the SystemGeolocator error") {
                    guard let result = unwrap(result) else { return }
                    expect(result).to(equal(Error.someError))
                }
            }

            context("when SystemGeolocator fails in returning anything at all") {
                var result: Geolocator.Error?
                setup {
                    guard let (sut, disposeBag) = unwrap(sut, disposeBag) else { return }
                    sut.geolocate(address: "Valencia Airport")
                        .subscribe(onError: { result = $0 as? Geolocator.Error })
                        .disposed(by: disposeBag)
                }
                it("should return the dedicated Geolocator error") {
                    guard let result = unwrap(result) else { return }
                    expect(result).to(equal(Geolocator.Error.geolocationFailedForUnknownReason))
                }
            }

            context("along geolocating process") {
                setup {
                    guard let systemGeolocator = unwrap(systemGeolocator) else { return }
                    systemGeolocator.shouldReturnAtAll = false
                }
                context("before the geolocation is started") {
                    it("should have its SystemGeolocator reports it's not geolocating") {
                        guard let systemGeolocator = unwrap(systemGeolocator) else { return }
                        expect(systemGeolocator.isGeocoding).to(beFalse())
                    }
                }

                context("after the geolocation is started") {
                    var disposable: Disposable?
                    setup {
                        guard let sut = unwrap(sut) else { return }
                        disposable = sut.geolocate(address: "Valencia Airport").subscribe()
                    }

                    context("during geolocating process") {
                        it("should have its SystemGeolocator reports it is geolocating") {
                            guard let systemGeolocator = unwrap(systemGeolocator) else { return }
                            expect(systemGeolocator.isGeocoding).to(beTrue())
                        }
                    }

                    context("after unsubscribing from geolocation") {
                        setup {
                            guard let disposable = unwrap(disposable) else { return }
                            disposable.dispose()
                        }
                        it("should have its SystemGeolocator reports it is geolocating") {
                            guard let systemGeolocator = unwrap(systemGeolocator) else { return }
                            expect(systemGeolocator.isGeocoding).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}

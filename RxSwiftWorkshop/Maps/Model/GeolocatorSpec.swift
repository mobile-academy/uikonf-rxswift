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
        describes("Geolocator") {

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

            condition("always") {
                let address = "Valencia Airport"
                setup {
                    sut?.geolocate(address: address).subscribe().disposed(by: disposeBag!)
                }
                it("should pass geolocation request to its SystemGeolocator") {
                    systemGeolocator!.verifyCall(
                        withIdentifier: FakeSystemGeolocator.Identifiers.geocodeAddressString, arguments: [address]
                    )
                }
            }

            condition("when SystemGeolocator succeeds in finding location") {
                let location = CLLocation(latitude: 123.123, longitude: 132.132)
                var result: CLLocation?
                setup {
                    systemGeolocator!.fixedLocation = location
                    sut!.geolocate(address: "Valencia Airport")
                        .subscribe(onNext: { result = $0 })
                        .disposed(by: disposeBag!)
                }
                it("should return this location") {
                    expect(result!.coordinate).to(equal(location.coordinate))
                }
            }

            condition("when SystemGeolocator fails in finding location") {
                enum Error: Swift.Error { case someError }
                var result: Error?
                setup {
                    systemGeolocator!.fixedError = Error.someError
                    sut!.geolocate(address: "Valencia Airport")
                        .subscribe(onError: { result = $0 as? Error })
                        .disposed(by: disposeBag!)
                }
                it("should return the SystemGeolocator error") {
                    expect(result!).to(equal(Error.someError))
                }
            }

            condition("when SystemGeolocator fails in returning anything at all") {
                var result: Geolocator.Error?
                setup {
                    sut!.geolocate(address: "Valencia Airport")
                        .subscribe(onError: { result = $0 as? Geolocator.Error })
                        .disposed(by: disposeBag!)
                }
                it("should return the dedicated Geolocator error") {
                    expect(result!).to(equal(Geolocator.Error.geolocationFailedForUnknownReason))
                }
            }

            condition("along geolocating process") {
                setup {
                    systemGeolocator!.shouldReturnAtAll = false
                }
                condition("before the geolocation is started") {
                    it("should have its SystemGeolocator reports it's not geolocating") {
                        expect(systemGeolocator!.isGeocoding).to(beFalse())
                    }
                }

                condition("after the geolocation is started") {
                    var disposable: Disposable?
                    setup {
                        disposable = sut!.geolocate(address: "Valencia Airport").subscribe()
                    }

                    context("during geolocating process") {
                        it("should have its SystemGeolocator reports it is geolocating") {
                            expect(systemGeolocator!.isGeocoding).to(beTrue())
                        }
                    }

                    condition("after unsubscribing from geolocation") {
                        setup {
                            disposable!.dispose()
                        }
                        it("should have its SystemGeolocator reports it is geolocating") {
                            expect(systemGeolocator!.isGeocoding).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}

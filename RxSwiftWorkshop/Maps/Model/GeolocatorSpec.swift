//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift

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
                guard let geolocator = unwrap(systemGeolocator) else { return }
                let address = "Valencia Airport"
                sut?.geolocate(address: address)
                geolocator.verifyCall(
                    withIdentifier: FakeSystemGeolocator.Identifiers.geocodeAddressString, arguments: [address]
                )
            }

            //            it("should return geolocation response from its SystemGeolocator") {
            //                guard let disposeBag = try? unwrap(disposeBag) else { return }
            //                let address = "Valencia Airport"
            //                sut?.geolocate(address: address).subscribe(onNext: {}).disposed(by: disposeBag!)
            //                systemGeolocator!.verifyCall(
            //                    withIdentifier: FakeSystemGeolocator.Identifiers.geocodeAddressString, arguments: [address]
            //                )
            //            }
        }
    }
}

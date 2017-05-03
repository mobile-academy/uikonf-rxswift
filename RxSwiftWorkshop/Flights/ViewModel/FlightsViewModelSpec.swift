//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest

@testable import RxSwiftWorkshop

final class FlightsViewModelSpec: QuickSpec {
    override func spec() {
        describe("FlightsService") {

            var sut: FlightsViewModel!
            var schipolService: FakeSchipolService!
            var iataService: FakeIATAService!

            var scheduler: TestScheduler!

            beforeEach {
                scheduler = TestScheduler(initialClock: 0)

                schipolService = FakeSchipolService()
                iataService = FakeIATAService()
            }

            afterEach {
                sut = nil
                scheduler = nil
            }

            describe("refreshing flights") {

                context("basic scenario with 1 flight, 1 airport") {
                    var disposeBag: DisposeBag!

                    beforeEach {
                        disposeBag = DisposeBag()
                        schipolService.observable = scheduler.createColdObservable([next(0, self.sampleFlights()), completed(0)]).asObservable()
                        iataService.airportObservable = scheduler.createColdObservable([next(0, self.sampleAirport()), completed(0)]).asObservable()
                        sut = FlightsViewModel(schipolCallable: schipolService, iataCallable: iataService)
                        sut.refresh().disposed(by: disposeBag)
                        scheduler.start()
                    }

                    afterEach {
                        disposeBag = nil
                    }

                    it("should have 1 flight") {
                        expect(sut.flights.value.count).to(equal(1))
                    }

                    it("should match flight id") {
                        expect(sut.flights.value.first?.id).to(equal(self.sampleFlights().first?.id))
                    }

                    it("should match destination airports") {
                        expect(sut.flights.value.first?.destinations).to(equal([self.sampleAirport()]))
                    }
                }
            }
        }
    }
}

extension FlightsViewModelSpec {
    func sampleFlights() -> [Flight] {
        return [
            Flight(id: 1,
                   name: "HV123",
                   number: 123,
                   schedule: Date(),
                   prefixIATA: "ABC",
                   serviceType: .passengerLine,
                   mainFlight: "HV123",
                   codeshares: [],
                   terminal: 13,
                   gate: "E08",
                   destinationCodes: ["WAW"]),
        ]
    }

    func sampleAirport() -> Airport {
        return Airport(code: "WAW", name: "Chopin Airport")
    }
}

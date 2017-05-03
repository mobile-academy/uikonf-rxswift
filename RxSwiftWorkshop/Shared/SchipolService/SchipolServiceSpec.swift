//
// Created by Maciej Oczko on 02.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest
import SwiftDate

@testable import RxSwiftWorkshop

final class SchipolServiceSpec: QuickSpec {
    override func spec() {
        describe("SchipolService") {

            var sut: SchipolService!
            var client: FakeAPIClient!
            var keys: FakeSchipolKeys!

            var scheduler: TestScheduler!

            beforeEach {
                client = FakeAPIClient()
                keys = FakeSchipolKeys()
                sut = SchipolService(client: client, keys: keys)

                scheduler = TestScheduler(initialClock: 0)
            }

            afterEach {
                sut = nil
                scheduler = nil
            }

            describe("flights endpoint") {
                var observer: TestableObserver<[Flight]>!

                beforeEach {
                    client.observable = scheduler.createColdObservable([next(0, self.sampleJSON()), completed(0)]).asObservable()
                    observer = scheduler.start {
                        sut.flights()
                    }
                }

                it("should call proper request") {
                    let urlString = SchipolService.Constants.baseURL + "flights?app_id=\(keys.schipholAPIAppID)&app_key=\(keys.schipholAPIAppKey)"
                    var request = URLRequest(url: URL(string: urlString)!)
                    request.httpMethod = "GET"
                    request.addValue("v3", forHTTPHeaderField: "ResourceVersion")
                    client.verifyCall(withIdentifier: "call", arguments: [request])
                }

                describe("model from response") {
                    var flights: [Flight]?

                    beforeEach {
                        flights = observer.events[0].value.element
                    }

                    it("should get 7 flights") {
                        expect(flights?.count).to(equal(2))
                    }

                    it("should get properly parsed Flight model") {
                        guard let flight = flights?.first else { fatalError("That shouldn't happen.") }
                        let date = DateInRegion(string: "2017-05-02T00:05:00", format: .iso8601Auto)?.absoluteDate
                        expect(date).notTo(beNil())

                        expect(flight).to(equal(Flight(id: 121_693_363_192_857_714,
                                                       name: "HV740",
                                                       number: 740,
                                                       schedule: date!,
                                                       prefixIATA: "HV",
                                                       serviceType: .passengerLine,
                                                       mainFlight: "HV740",
                                                       codeshares: [],
                                                       terminal: 3,
                                                       gate: "E08",
                                                       statuses: [.arrived],
                                                       destinationCodes: ["AYT"])
                        ))
                    }
                }
            }
        }
    }
}

extension SchipolServiceSpec {
    func sampleJSON() -> [String: Any] {
        let first: [String: Any?] = [
            "id": 121_693_363_192_857_714,
            "flightName": "HV740",
            "scheduleDate": "2017-05-02",
            "flightDirection": "A",
            "flightNumber": 740,
            "prefixIATA": "HV",
            "prefixICAO": "TRA",
            "scheduleTime": "00:05:00",
            "serviceType": "J",
            "mainFlight": "HV740",
            "codeshares": nil,
            "estimatedLandingTime": "2017-05-01T23:59:32.000+02:00",
            "actualLandingTime": "2017-05-01T23:59:32.000+02:00",
            "publicEstimatedOffBlockTime": nil,
            "actualOffBlockTime": nil,
            "publicFlightState": [
                "flightStates": [
                    "ARR",
                ],
            ],
            "route": [
                "destinations": [
                    "AYT",
                ],
            ],
            "terminal": 3,
            "gate": "E08",
            "baggageClaim": [
                "belts": [
                    "15B",
                ],
            ],
            "expectedTimeOnBelt": "2017-05-02T01:04:11.981+02:00",
            "checkinAllocations": nil,
            "transferPositions": nil,
            "aircraftType": [
                "iatamain": "73H",
                "iatasub": "73H",
            ],
            "aircraftRegistration": "PHGGX",
            "airlineCode": 164,
            "expectedTimeGateOpen": nil,
            "expectedTimeBoarding": nil,
            "expectedTimeGateClosing": nil,
            "schemaVersion": "3",
        ]
        let second: [String: Any?] = [
            "id": 121_693_364_355_951_826,
            "flightName": "HV6730",
            "scheduleDate": "2017-05-02",
            "flightDirection": "A",
            "flightNumber": 6730,
            "prefixIATA": "HV",
            "prefixICAO": "TRA",
            "scheduleTime": "00:10:00",
            "serviceType": "J",
            "mainFlight": "HV6730",
            "codeshares": [
                "codeshares": [
                    "KL2688",
                ],
            ],
            "estimatedLandingTime": "2017-05-02T00:27:39.000+02:00",
            "actualLandingTime": "2017-05-02T00:27:39.000+02:00",
            "publicEstimatedOffBlockTime": nil,
            "actualOffBlockTime": nil,
            "publicFlightState": [
                "flightStates": [
                    "ARR",
                    "EXP",
                ],
            ],
            "route": [
                "destinations": [
                    "SVQ",
                ],
            ],
            "terminal": 1,
            "gate": "D61",
            "baggageClaim": [
                "belts": [
                    "4",
                ],
            ],
            "expectedTimeOnBelt": "2017-05-02T01:01:00.000+02:00",
            "checkinAllocations": nil,
            "transferPositions": nil,
            "aircraftType": [
                "iatamain": "73H",
                "iatasub": "73H",
            ],
            "aircraftRegistration": "PHHSK",
            "airlineCode": 164,
            "expectedTimeGateOpen": nil,
            "expectedTimeBoarding": nil,
            "expectedTimeGateClosing": nil,
            "schemaVersion": "3",
        ]

        return [
            "flights": [first, second],
            "schemaVersion": "3",
        ]
    }
}

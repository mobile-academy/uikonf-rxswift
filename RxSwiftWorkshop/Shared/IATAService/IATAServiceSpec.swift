//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest
import Mimus

@testable import RxSwiftWorkshop

final class IATAServiceSpec: QuickSpec {
    override func spec() {
        describe("IATAService") {

            var sut: IATAService!
            var client: FakeAPIClient!
            var keys: FakeIATAKeys!

            var scheduler: TestScheduler!

            beforeEach {
                client = FakeAPIClient()
                keys = FakeIATAKeys()
                sut = IATAService(client: client, keys: keys)

                scheduler = TestScheduler(initialClock: 0)
            }

            afterEach {
                sut = nil
            }

            describe("airline endpoint") {
                var observer: TestableObserver<Airline>!

                beforeEach {
                    let json: ResponseJSON = [
                        "response": [
                            ["code": "LT", "name": "LTU Airways"],
                        ],
                    ]
                    client.observable = scheduler.createColdObservable([next(0, json), completed(0)]).asObservable()
                    observer = scheduler.start {
                        sut.airline(for: "LT")
                    }
                }

                it("should call proper request") {
                    let urlString = IATAService.Constants.baseURL.absoluteString + "airlines?api_key=\(keys.iATACodesAPIKey)&code=LT"
                    var request = URLRequest(url: URL(string: urlString)!)
                    request.httpMethod = "GET"
                    client.verifyCall(withIdentifier: "call", arguments: [request])
                }

                it("should get valid airline model") {
                    expect(observer.events[0].value.element).to(equal(Airline(code: "LT", name: "LTU Airways")))
                }
            }

            describe("airports endpoint") {
                var observer: TestableObserver<Airport>!

                beforeEach {
                    let json: ResponseJSON = [
                        "response": [
                            ["code": "CDG", "name": "Charles De Gaulle"],
                        ],
                    ]
                    client.observable = scheduler.createColdObservable([next(0, json), completed(0)]).asObservable()
                    observer = scheduler.start {
                        sut.airport(for: "CDG")
                    }
                }

                it("should call proper request") {
                    let urlString = IATAService.Constants.baseURL.absoluteString + "airports?api_key=\(keys.iATACodesAPIKey)&code=CDG"
                    var request = URLRequest(url: URL(string: urlString)!)
                    request.httpMethod = "GET"
                    client.verifyCall(withIdentifier: "call", arguments: [request])
                }

                it("should get valid airport model") {
                    expect(observer.events[0].value.element).to(equal(Airport(code: "CDG", name: "Charles De Gaulle")))
                }
            }
        }
    }
}

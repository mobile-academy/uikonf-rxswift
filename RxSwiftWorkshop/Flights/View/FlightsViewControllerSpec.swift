//
// Created by Maciej Oczko on 03.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest
import Mimus

@testable import RxSwiftWorkshop

final class FlightsViewControllerSpec: QuickSpec {
    override func spec() {
        describe("FlightsViewController") {

            var sut: FlightsViewController!
            var flightsViewModel: FakeFlightsViewModel!

            var scheduler: TestScheduler!
            var observable: TestableObservable<[Flight]>!

            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                observable = scheduler.createColdObservable([next(0, [self.sampleFlight()]), completed(0)])

                flightsViewModel = FakeFlightsViewModel(observable: observable.asObservable())
                sut = FlightsViewController(viewModel: flightsViewModel)
            }

            afterEach {
                sut = nil
                scheduler = nil
            }

            it("should have 'Flights' title") {
                expect(sut.title).to(equal("Flights"))
            }

            it("should have table view as main view") {
                expect(sut.view).to(beAKindOf(UITableView.self))
            }

            context("table view") {
                var tableView: UITableView!

                beforeEach {
                    scheduler.start()
                    // `sut.view` calls loadView & viewDidLoad
                    tableView = sut.view as! UITableView
                    // set frame to ensure table displays cells
                    sut.view.frame = CGRect(x: 0, y: 0, width: 320, height: 100)
                    sut.viewDidAppear(false)
                }

                it("should disallow selection") {
                    expect(tableView.allowsSelection).to(beFalse())
                }

                it("should refresh items at view did appear") {
                    flightsViewModel.verifyCall(withIdentifier: "refresh")
                }

                it("should have one flight in view model") {
                    expect(flightsViewModel.flights.value.count).to(equal(1))
                }

                describe("table view items") {
                    var cell: UITableViewCell?

                    beforeEach {
                        cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                    }

                    it("should have one cell visible") {
                        expect(tableView.visibleCells.count).to(equal(1))
                    }

                    it("should display one cell") {
                        expect(cell).notTo(beNil())
                    }

                    it("should be flights cell") {
                        expect(cell).to(beAKindOf(FlightCell.self))
                    }
                }
            }
        }
    }
}

extension FlightsViewControllerSpec {
    func sampleFlight() -> Flight {
        return Flight(id: 121_693_363_192_857_714,
                      name: "HV740",
                      number: 740,
                      schedule: Date(),
                      prefixIATA: "HV",
                      serviceType: .passengerLine,
                      mainFlight: "HV740",
                      codeshares: [],
                      terminal: 3,
                      gate: "E08",
                      statuses: [.arrived],
                      destinationCodes: ["AYT"])
    }
}

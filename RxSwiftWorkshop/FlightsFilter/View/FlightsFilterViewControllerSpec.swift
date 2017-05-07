//
// Created by Maciej Oczko on 10.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest

@testable import RxSwiftWorkshop
@testable import RxCocoa

final class FlightsFilterViewControllerSpec: QuickSpec {
    override func spec() {
        describe("FlightsFilterViewController") {

            var sut: FlightsFilterViewController!

            var dismissCallbackCheck: (() -> Void)?
            var flightFilterCallbackCheck: ((FlightsFilter?) -> Void)?

            beforeEach {
                sut = FlightsFilterViewController(
                    filterChange: {
                        filter in
                        flightFilterCallbackCheck?(filter)
                    },
                    dismissViewController: {
                        dismissCallbackCheck?()
                    }
                )
            }

            afterEach {
                dismissCallbackCheck = nil
                sut = nil
            }

            describe("basic setup") {
                it("should have proper title") {
                    expect(sut.title).to(equal("Flights Filter"))
                }

                it("should have proper view") {
                    expect(sut.view).to(beAKindOf(FlightsFilterView.self))
                }
            }

            describe("filter") {
                var flightFilter: FlightsFilter?

                describe("set") {
                    var scheduler: TestScheduler!
                    var flightFilterView: FakeFlightsFilterView!

                    beforeEach {
                        flightFilter = nil

                        scheduler = TestScheduler(initialClock: 0)
                        flightFilterView = FakeFlightsFilterView()
                        flightFilterView.fromDateStringObservable = scheduler.createHotObservable([next(1, "2017-05-10")]).asObservable()
                        flightFilterView.toDateStringObservable = scheduler.createHotObservable([next(2, "2017-05-17")]).asObservable()
                        sut.view = flightFilterView
                        sut.viewDidLoad()

                        flightFilterCallbackCheck = {
                            filter in
                            flightFilter = filter
                        }

                        scheduler.advanceTo(2)

                        let applyBarButtonItem = sut.navigationItem.rightBarButtonItems?[0]
                        applyBarButtonItem?.simulateTap()
                    }

                    it("should set to proper flight filter") {
                        expect(flightFilter).to(equal(FlightsFilter(fromDate: "2017-05-10", toDate: "2017-05-17")))
                    }
                }

                describe("reset") {
                    beforeEach {
                        // Ensure that it has value, initially
                        flightFilter = FlightsFilter(fromDate: nil, toDate: nil)

                        flightFilterCallbackCheck = {
                            filter in
                            flightFilter = filter
                        }

                        _ = sut.view
                        let resetBarButtonItem = sut.navigationItem.rightBarButtonItems?[1]
                        resetBarButtonItem?.simulateTap()
                    }

                    it("should be nil") {
                        expect(flightFilter).to(beNil())
                    }
                }
            }

            describe("close bar button item") {
                var leftBarButtonItem: UIBarButtonItem?

                beforeEach {
                    _ = sut.view
                    leftBarButtonItem = sut.navigationItem.leftBarButtonItem
                }

                it("should not be nil") {
                    expect(leftBarButtonItem).notTo(beNil())
                }

                it("should have proper title") {
                    expect(leftBarButtonItem?.title).to(equal("Close"))
                }

                describe("dismissing view controller") {
                    var dismissed: Bool?

                    beforeEach {
                        dismissed = false
                        dismissCallbackCheck = {
                            dismissed = true
                        }
                        leftBarButtonItem?.simulateTap()
                    }

                    it("should call dismissing callback") {
                        expect(dismissed).to(beTrue())
                    }
                }
            }

            describe("apply bar button item") {
                var applyBarButtonItem: UIBarButtonItem?

                beforeEach {
                    _ = sut.view
                    applyBarButtonItem = sut.navigationItem.rightBarButtonItems?[0]
                }

                it("should not be nil") {
                    expect(applyBarButtonItem).notTo(beNil())
                }

                it("should have proper title") {
                    expect(applyBarButtonItem?.title).to(equal("Apply"))
                }

                describe("dismissing view controller") {
                    var dismissed: Bool?

                    beforeEach {
                        dismissed = false
                        dismissCallbackCheck = {
                            dismissed = true
                        }
                        applyBarButtonItem?.simulateTap()
                    }

                    it("should call dismissing callback") {
                        expect(dismissed).to(beTrue())
                    }
                }
            }

            describe("reset bar button item") {
                var resetBarButtonItem: UIBarButtonItem?

                beforeEach {
                    _ = sut.view
                    resetBarButtonItem = sut.navigationItem.rightBarButtonItems?[1]
                }

                it("should not be nil") {
                    expect(resetBarButtonItem).notTo(beNil())
                }

                it("should have proper title") {
                    expect(resetBarButtonItem?.title).to(equal("Reset"))
                }

                describe("dismissing view controller") {
                    var dismissed: Bool?

                    beforeEach {
                        dismissed = false
                        dismissCallbackCheck = {
                            dismissed = true
                        }
                        resetBarButtonItem?.simulateTap()
                    }

                    it("should call dismissing callback") {
                        expect(dismissed).to(beTrue())
                    }
                }
            }
        }
    }
}

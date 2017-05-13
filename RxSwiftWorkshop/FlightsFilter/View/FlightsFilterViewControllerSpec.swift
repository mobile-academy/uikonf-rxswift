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

            var dismissCheckCallback: (() -> Void)?
            var filterChangeCheckCallback: ((FlightsFilter?) -> Void)?

            beforeEach {
                sut = FlightsFilterViewController(filterChange: {
                    filter in
                    filterChangeCheckCallback?(filter)
                }, dismissViewController: {
                    dismissCheckCallback?()
                })
            }

            afterEach {
                filterChangeCheckCallback = nil
                dismissCheckCallback = nil
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

                describe("reseting") {
                    var closeBarButtonItem: UIBarButtonItem?
                    var flightsFilter: FlightsFilter?

                    beforeEach {
                        flightsFilter = nil
                        filterChangeCheckCallback = {
                            filter in
                            flightsFilter = filter
                        }
                        _ = sut.view
                        closeBarButtonItem = sut.navigationItem.leftBarButtonItem
                        if let target = closeBarButtonItem?.target as? BarButtonItemTarget {
                            target.callback()
                        }
                    }

                    it("should be nil") {
                        expect(flightsFilter).to(beNil())
                    }
                }

                describe("setting") {
                    var scheduler: TestScheduler!
                    var flightsFilter: FlightsFilter?
                    var filterView: FakeFlightFilterView!

                    beforeEach {
                        scheduler = TestScheduler(initialClock: 0, resolution: 1.0, simulateProcessingDelay: false)

                        flightsFilter = nil
                        filterChangeCheckCallback = {
                            filter in
                            flightsFilter = filter
                        }

                        filterView = FakeFlightFilterView()
                        filterView.fromDateStringObservable = scheduler.createHotObservable([next(1, "2017-05-10")]).asObservable()
                        filterView.toDateStringObservable = scheduler.createHotObservable([next(1, "2017-05-15")]).asObservable()
                        sut.view = filterView
                        sut.viewDidLoad()
                    }

                    context("when apply button is not tapped") {
                        beforeEach {
                            scheduler.advanceTo(2)
                        }

                        it("should be nil") {
                            expect(flightsFilter).to(beNil())
                        }
                    }

                    fcontext("when apply button is tapped") {
                        var applyBarButtonItem: UIBarButtonItem?

                        beforeEach {
                            applyBarButtonItem = sut.navigationItem.rightBarButtonItems?[0]

                            scheduler.advanceTo(2)

                            if let target = applyBarButtonItem?.target as? BarButtonItemTarget {
                                target.callback()
                            }
                        }

                        it("should have correct value") {
                            expect(flightsFilter).to(equal(FlightsFilter(fromDate: "2017-05-10", toDate: "2017-05-15")))
                        }
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
                        dismissCheckCallback = {
                            dismissed = true
                        }
                        if let target = leftBarButtonItem?.target as? BarButtonItemTarget {
                            target.callback()
                        }
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
                        dismissCheckCallback = {
                            dismissed = true
                        }
                        if let target = applyBarButtonItem?.target as? BarButtonItemTarget {
                            target.callback()
                        }
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
                        dismissCheckCallback = {
                            dismissed = true
                        }
                        if let target = resetBarButtonItem?.target as? BarButtonItemTarget {
                            target.callback()
                        }
                    }

                    it("should call dismissing callback") {
                        expect(dismissed).to(beTrue())
                    }
                }
            }
        }
    }
}

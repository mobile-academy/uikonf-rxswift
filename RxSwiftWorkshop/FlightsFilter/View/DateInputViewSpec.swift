//
// Created by Maciej Oczko on 14.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest

@testable import RxSwiftWorkshop

final class DateInputViewSpec: QuickSpec {
    override func spec() {
        describe("DateInputView") {

            var sut: DateInputView!

            beforeEach {
                sut = DateInputView(title: "fixture title")
            }

            afterEach {
                sut = nil
            }

            it("should have proper title set") {
                expect(sut.titleLabel.text).to(equal("fixture title"))
            }

            describe("date string observable") {
                var scheduler: TestScheduler!
                var observer: TestableObserver<String?>!

                beforeEach {
                    scheduler = TestScheduler(initialClock: 0)
                }

                context("when year, month and day are set") {
                    beforeEach {
                        sut.yearInputView.inputField.rx.text.on(.next("2017"))
                        sut.monthInputView.inputField.rx.text.on(.next("05"))
                        sut.dayInputView.inputField.rx.text.on(.next("10"))

                        observer = scheduler.start {
                            sut.dateStringObservable
                        }
                    }

                    it("should send valid date string") {
                        expect(observer.events[0].value.element.flatMap { $0 }).to(equal("2017-05-10"))
                    }
                }

                context("when any of year, month, day is not set") {
                    beforeEach {
                        sut.yearInputView.inputField.rx.text.on(.next("2017"))
                        sut.monthInputView.inputField.rx.text.on(.next("05"))
                        sut.dayInputView.inputField.rx.text.on(.next(nil))

                        observer = scheduler.start {
                            sut.dateStringObservable
                        }
                    }

                    it("should send nil") {
                        expect(observer.events[0].value.element.flatMap { $0 }).to(beNil())
                    }
                }
            }
        }
    }
}

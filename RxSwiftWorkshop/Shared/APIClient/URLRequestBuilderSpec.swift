//
// Created by Maciej Oczko on 01.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest

@testable import RxSwiftWorkshop

final class URLRequestBuilderSpec: QuickSpec {
    override func spec() {
        describe("URLRequestBuilder") {

            var sut: URLRequestBuilder!

            var scheduler: TestScheduler!
            var observer: TestableObserver<URLRequest>!

            beforeEach {
                let url = URL(string: "http://example.com/")!
                sut = URLRequestBuilder(base: url)

                scheduler = TestScheduler(initialClock: 0)
            }

            afterEach {
                scheduler = nil
                observer = nil
                sut = nil
            }

            describe("building request without query items") {
                beforeEach {
                    observer = scheduler.start {
                        sut.build(for: "path").asObservable()
                    }
                }

                it("should result in http://example.com/path") {
                    var expectedRequest = URLRequest(url: URL(string: "http://example.com/path")!)
                    expectedRequest.httpMethod = "GET"
                    expect(observer.events[0].value.element).to(equal(expectedRequest))
                }
            }

            describe("building request with query items") {
                beforeEach {
                    observer = scheduler.start {
                        sut.build(for: "path", with: [
                            URLQueryItem(name: "key", value: "123"),
                            URLQueryItem(name: "value", value: "321"),
                        ]).asObservable()
                    }
                }

                it("should result in http://example.com/path?key=123&value=321") {
                    var expectedRequest = URLRequest(url: URL(string: "http://example.com/path?key=123&value=321")!)
                    expectedRequest.httpMethod = "GET"
                    expect(observer.events[0].value.element).to(equal(expectedRequest))
                }
            }
        }
    }
}

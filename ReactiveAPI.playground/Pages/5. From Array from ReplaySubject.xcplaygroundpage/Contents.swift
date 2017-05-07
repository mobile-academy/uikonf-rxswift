//: [Previous](@previous)

import Foundation
import RxSwift

let disposeBag = DisposeBag()

let integers = [10, 20, 30, 40, 50]

let subjectReplayingAll = ReplaySubject<Int>.createUnbounded()

subjectReplayingAll.subscribe {
    print($0)
}.disposed(by: disposeBag)


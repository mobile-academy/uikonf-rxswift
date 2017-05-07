//: [Previous](@previous)

import Foundation
import RxSwift

let disposeBag = DisposeBag()

let integers = [10, 20, 30, 40, 50]

let subjectReplayingAll = ReplaySubject<Int>.createUnbounded()

for elem in integers {
    subjectReplayingAll.onNext(elem)
}
subjectReplayingAll.onCompleted()

subjectReplayingAll.subscribe {
    print($0)
}.disposed(by: disposeBag)


//: [Previous](@previous)

import Foundation
import RxSwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let disposeBag = DisposeBag()

// PLEASE CHANGE THIS VALUE TO ANY GITHUB NAME YOU LIKE :)
let user = "UIKonf"

let url = URL(string: "https://api.github.com/users/\(user)")!

enum JsonError: Swift.Error {
    case noParsableData
}

extension Observable where E == Any {
    static func json(url: URL) -> Observable<E> {
        return .empty()
    }
}

Observable.json(url: url).subscribe { event in
    print(event)
}.disposed(by: disposeBag)

//: [Next: From Array from PublishSubject](@next)

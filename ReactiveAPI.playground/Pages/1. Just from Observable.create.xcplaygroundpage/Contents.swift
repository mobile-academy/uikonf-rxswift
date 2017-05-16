import Foundation
import RxSwift

let disposeBag = DisposeBag()

let elem = "🙈"

extension Observable {
    static func myJust(element: E) -> Observable<E> {
        return .empty()
    }
}

Observable.myJust(element: elem).subscribe {
    print($0)
}.disposed(by: disposeBag)

//: [Next: From Array from Observable.create](@next)

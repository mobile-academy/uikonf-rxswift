import Foundation
import RxSwift

let disposeBag = DisposeBag()

let elem = "🙈"

extension Observable {
    static func myJust(element: E) -> Observable<E> {
        return Observable<E>.create { observer in
            observer.onNext(element)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

Observable.myJust(element: elem).subscribe {
    print($0)
}.disposed(by: disposeBag)

//: [Next: From Array from Observable.create](@next)

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
        return Observable<E>.create { observer in
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("RxUIKonfWorkshop-\(user)", forHTTPHeaderField: "User-Agent")
            var task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                if let data = data,
                   let result = try? JSONSerialization.jsonObject(with: data) {
                    observer.onNext(result)
                    observer.onCompleted()
                } else if let error = error {
                    observer.onError(error)
                } else {
                    observer.onError(JsonError.noParsableData)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

Observable.json(url: url).subscribe { event in
    print(event)
}.disposed(by: disposeBag)

//: [Next: From Array from PublishSubject](@next)

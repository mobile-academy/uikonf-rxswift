//: [Previous](@previous)

import Foundation
import RxSwift

//: # Memory Management - Part Two
//:
//: In previous example we learned that certain sequence observers are automatically disposed when a sequence completes.
//:
//: You probably wonder - what if I have a sequence that never completes? Or a sequence that won't complete before my object should be deallocated?
//: In this case we need to manually dispose of the sequence observer. There are two ways of doing this.
//:

// Let's assume that this sequence will never finish.
let observable = Observable.from(["🙅🏻‍♂️"])

// A result of subscribing to a sequence is a Disposable object.
let disposable: Disposable = observable
    .subscribe(onNext: { print("\($0)") })

// In order to manually dispose of it you can call
disposable.dispose()

// This will deallocate subscribed callbacks, thus releasing any resources captured by them.

// Another way of disposing, one that is much more elegant, is using a `DisposeBag`.
var exampleDisposeBag = DisposeBag()

// You can add a disposable to dispose bag by calling
disposable.disposed(by: exampleDisposeBag)

// In order to dispose of all registered sequence observers within a dispose bag you just need to deallocate dispose bag. You can do so by, for instance, replacing it with a new value:
exampleDisposeBag = DisposeBag()

//:
//: ## Assignment
//: 
//: Your task is to dispose of a registered observer using a dispose bag. In this scenario we'll use a sequence that does not complete immediately - a `Variable`. `Variable` stores a value within and sends an event each time you update that value by calling `variable.value = x`.
//:

var disposeBag = DisposeBag()
var variable = Variable(1)

variable
    .asObservable()
    .subscribe(
        onNext: { print("\($0)") },
        onDisposed: { print("I'd love to be printed - calling from disposed!") })

//: Bonus task - subscribe a closure that gets immediately disposed.

//: [Putting it all together](@next)


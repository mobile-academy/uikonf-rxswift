//: [Previous](@previous)
import Foundation
import RxSwift
//:
//: # Completion and Errors
//:
//: As you already know in Rx Sequences take from both Iterator and Observer patterns. Let's take a look at another aspect of Iterator Type that got incorporated into Rx.
//:
//: In Rx a sequence can emit a `onCompleted` event. This means that the sequence has completed and no further elements will be received. In our case of simple observables created from arrays of values `onCompleted` events are sent after all values in given sequence have been passed:

let integers = [10, 20, 30, 40, 50, 60]
let observable = Observable.from(integers)

observable
    .subscribe(
        onNext: { print("The value is: \($0)")},
        onError: { print("Sequence failed with error \($0)") },
        onCompleted: { print("Sequence completed") }
)

//: You'll learn more about `onError` event at a later stage of this workshop. At this point it's worth mentioning that no more elements can be received if `onError` has been called.
//:
//: [Memory Management](@next)

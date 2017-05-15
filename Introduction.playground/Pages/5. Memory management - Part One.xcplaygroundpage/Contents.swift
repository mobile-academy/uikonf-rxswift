//: [Previous](@previous)

import Foundation
import RxSwift

//: 
//: # Memory management
//:
//: Let's take a look how memory management works in RxSwift.
//: You probably wonder at this point: how does the memory management work? When are those subscriber closures deallocated? Who owns what? How can I force an observer closure to be deallocated? 
//:
//: Let's go back to our initial example. 
//: 

let animals = Observable.from(["🐶", "🐱", "🐭", "🐹"])

//: 
//: In RxSwift you can register additional callback that will be called when your subscribed callbacks are disposed of. You can think about disposing as releasing all relevant resources of given registered observer.
//: 

animals
    .subscribe(
        onNext: { print($0) },
        onDisposed: { print("Observer disposed") }
)

//:
//: Note that our subscriber has been automatically disposed after it received all events and we did not have to do any additional setup. This happened because our sequence has a finite amount of values - it runs through all animals and completes immediately afterwards. Since it completed and there are no new values expected (this is a strong assumption of Rx - you can't receive more events after `onCompleted` or `onError`) there is no point in keeping it in memory and this it gets automatically disposed of.
//:

//: [Memory Management - Part Two](@next)

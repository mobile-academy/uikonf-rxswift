//: [Previous](@previous)

import Foundation
import RxSwift

//: # Transforming sequences
//:
//: In this part we'll learn how to transform sequences. The most basic transform operator that's defined in RxSwift is `map`, which you probably already know from `Swift.Sequence`.

// Swift Map

let integers = [10, 20, 30, 40, 50, 60]
let strings = integers.map( { String($0) })

print("\(strings)")

// RxSwift Map

let observable = Observable.from(integers)
observable
    .map { String($0) }
    .subscribe(
        onNext: { print("The value is: \($0)")}
)

//:
//: # Assignment
//:
//: Your task is to take the sequence of people that's defined below and map it so that we receive a sequence of `String`. You can use persons first name. You should print that string afterwards. You'll need to use map operator that you can see in the example above.

let people = FixturePeople.make()

//: [Next Part: Filtering Sequences](@next)

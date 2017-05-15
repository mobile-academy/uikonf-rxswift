//: [Previous](@previous)

import Foundation
import RxSwift

//: # Filtering sequences
//:
//: In this part we'll learn how to filter sequences. Similar to transforming sequences we'll start with the most basic filter operator - `filter`, which also behaves in a very similar way to `Swift.Sequence.filter()`

// Swift Filter

let integers = [10, 20, 30, 40, 50, 60]
let filteredIntegers = integers.filter( { $0 > 30 })

print("\(filteredIntegers)")

// RxSwift Filter

let observable = Observable.from(integers)

observable
    .filter { $0 > 30 }
    .subscribe(
        onNext: { print("The value is: \($0)") }
)

//:
//: # Assignment
//:
//: Your task is to take the sequence of people that's defined below filter out people who are younger than 40. Print that `Person` structure afterwards. You'll need to use filter operator that you can see in the example above.

let people = FixturePeople.make()

//: [Next Part: Completion and Errors](@next)

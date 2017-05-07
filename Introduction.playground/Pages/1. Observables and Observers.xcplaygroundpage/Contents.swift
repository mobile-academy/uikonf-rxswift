
//: > # Imporant: Open this file from RxSwiftWorkshop.xcworkspace

import Foundation
import RxSwift

//: # Observables and Observers
//:
//: Let's start with the simplest thing - creating observable sequences and
//: registering observers. 

// In most of our examples in Introduction we'll use the simplest way to create a sequence:
let observable = Observable.from(["🐶", "🐱", "🐭", "🐹"])

// Now let's add some observer callbacks: 

observable
    .subscribe(onNext: { print("Value is: \($0)") })

//:
//: Assignment
//: 
//: Your task is to create an observable from array of people below, and print all the values that are in it. 

let people = FixturePeople.make()



//: [Next Part: Transforming Sequences](@next)


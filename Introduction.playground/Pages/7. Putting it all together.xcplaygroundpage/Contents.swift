//: [Previous](@previous)

import Foundation
import RxSwift

//: # Final introduction task
//: ## Let's merge all our knowledge together!
//: 
//: What we want you to do is to write Rx code that will take People defined below and:
//: 
//: 1. Filter out people who are older than 30
//: 3. Transform each entry so that we receive a string "Hello, my name is `firstName` `lastName` and I'm `x` yeards old"
//: 4. Print each value in the sequence
//: 5. Print "Finished!" after all values from sequence have been delivered

let people = FixturePeople.make()

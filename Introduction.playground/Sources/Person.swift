import Foundation

public struct Person {
    
    public let firstName: String
    
    public let lastName: String
    
    public let age: Int
}

public class FixturePeople {
    
    public static func make() -> [Person] {
        return [
            Person(firstName: "Anne", lastName: "Barrow", age: 28),
            Person(firstName: "Kristy", lastName: "Runyon", age: 62),
            Person(firstName: "Albert", lastName: "Thompson", age: 43),
            Person(firstName: "Wiga", lastName: "Wiśniewska", age: 21),
            Person(firstName: "Lea", lastName: "Eiffel", age: 49),
            Person(firstName: "Michael", lastName: "Duerr", age: 57),
            Person(firstName: "Monika", lastName: "Ackermann", age: 27),
        ]
    }
}

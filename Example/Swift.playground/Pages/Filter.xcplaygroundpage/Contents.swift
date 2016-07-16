//: [Previous](@previous)

import Foundation
import UIKit




let arr = ["FOO", "FOO", "BAR", "TALS", "FOOBAR", "TALS","FOO", "TALS"]

var counts:[String:Int] = [:]

for item in arr {
    counts[item] = (counts[item] ?? 0) + 1
}
print(counts)  // "[BAR: 1, FOOBAR: 1, FOO: 3]"

extension SequenceType where Self.Generator.Element: Hashable {
    
    func freq() -> [Self.Generator.Element: Int] {
        return reduce([:]) { (accu: [Self.Generator.Element: Int], element) in
            var accu = accu
            accu[element] = accu[element]?.successor() ?? 1
            return accu
        }
    }
    
    func indexes(search: Self.Generator.Element) -> [Int] {
        return enumerate().reduce([Int]()) { $1.1 == search ? $0 + [$1.0] : $0 }
    }
    
}
let counts2 = arr.freq()
print(counts2)

let me = counts2.flatMap { (elem, ind) -> String? in 

    if elem == "FOO" && ind == 3 {
        
        return elem
    }else{
        return nil
    }
}
print(me)


//extension Array where Element: Equatable {
//    func indexes(search: Element) -> [Int] {
//        return enumerate().reduce([Int]()) { $1.1 == search ? $0 + [$1.0] : $0 }
//    }
//}

let search = "FOO"
let indexesOfFOO = arr.indexes("FOO") // [3, 4]
//let indexesOfFOO = arr.enumerate().reduce([Int]()) { $1.1 == search ? $0 + [$1.0] : $0 }
print(indexesOfFOO[2])



for (key, value) in counts {
    print("\(key) occurs \(value) time(s)")
    
    if key == "FOO" && value == 3 {
        
        print("yess")
    }
}




class Person : NSObject {
    
    var firstName : String
    var lastName : String
    var imageFor : UIImage?
    var isManager : Bool?
    
    init (firstName : String, lastName: String, isManager : Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.isManager = isManager
    }
}

//var peopleArray = [Person]()
//
//let managersCount = peopleArray.filter { (person : Person) -> Bool in
//    return person.isManager!
//}.count
//
//let moreCount = peopleArray.filter{ $0.isManager! }.count



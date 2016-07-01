//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

var dict = [String : String]()
dict["what's"] = "up"
dict["george"] = "quentin"
dict["daniel"] = "asher"


var array = [(String, String)]()
array.append(("george", "quentin"))
array.append(("daniel", "asher"))

for key in dict.keys {
    key.hashValue
    print(dict[key], key.hashValue)
}

let hashValues = 
    dict.keys.map { ($0 , $0.hashValue) }.flatMap { $0 }

let pairs = 
    zip(hashValues, hashValues.dropFirst()).flatMap { $0 }

print(pairs)


let isOrderedByHashValue = 
    pairs.reduce(true) { acc, pair in 
        acc && pair.0 < pair.1 
    }

print("daniel".hashValue)


let a : String


let strings = ["Hello,","My","Name","Is","George"]

extension SequenceType where Generator.Element == String {
    
    func myJoinWithSeperator(seperator: String) -> String {
        return self.reduce("") { acc, string in
            return acc + seperator + string
        }
    }
}
 
strings.joinWithSeparator(" ")
strings.myJoinWithSeperator(" ")
//print(sentence)

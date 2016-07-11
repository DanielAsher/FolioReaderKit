//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

let a : Bool = true

class MyBool {
    let a = "George"
    let isWorking = true
}

let myBool = MyBool()

// make MyBool conform to protocol BooleanType
extension MyBool : BooleanType {
    var boolValue: Bool {
        return self.isWorking
    }
}

if myBool {
    print("Yes!")
}





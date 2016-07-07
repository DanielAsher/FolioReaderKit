//: [Previous](@previous)

import Foundation

var str = "Hello, playground"


let a = [1]
let b = [2,3]
let c = [4,5,6]

let d = [a,b,c]

let identityFunc : [Int] -> [Int] = { $0 }

let identityFunc2 : [Int] -> [Int] = 
    { (x: [Int]) -> [Int] in 
        return x 
    }

let f = identityFunc([10])

//: [Next](@next)
let flatArray 
    = d.flatMap(identityFunc)

let p = Optional<Int>.None

let qs : [Optional<Int>] = [1, 2, nil, 3, nil, 5, nil, 7]

if let value = qs[0] {
    print(value)
}


let rs =
        qs.flatMap { $0 }

let ccc = [[1,3],[5,7,94,2],[7,86,3,7],[8,3,23,33]]

let me = ["heklo", "me", "dgge", "dhjs"]

let reduce = me.reduce("",combine: +)




//print(ccc.flatMap{ $0 })


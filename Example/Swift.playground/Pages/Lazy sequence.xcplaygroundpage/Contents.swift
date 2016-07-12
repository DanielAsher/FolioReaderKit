//: [Previous](@previous)

import Foundation

var str = "Hello, playground"


let arr = Array(0...10000)

let result =
    arr
    .lazy // Comment this out to see much slower eager sequence performance.
    .map { x -> Int in
        let y = 7 * x
        print(y)
        return y
        }
    .filter { $0 > 100 && $0 < 110 }
    .first

print(result)


//: [Next](@next)

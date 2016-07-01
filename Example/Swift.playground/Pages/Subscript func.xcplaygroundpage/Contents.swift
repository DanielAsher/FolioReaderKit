//: Playground - noun: a place where people can play

import Foundation

struct TestSubscript {
    let names : [String]
    
    subscript (key: String) -> Bool {
        return names.contains(key)
    }
    
    func contains(key: String) -> Bool {
        return names.contains(key)

    }
    
}


let a = TestSubscript(names: ["Daniel", "George"])

a["Seb"]
a.contains("Seb")

var str = "Hello, playground"

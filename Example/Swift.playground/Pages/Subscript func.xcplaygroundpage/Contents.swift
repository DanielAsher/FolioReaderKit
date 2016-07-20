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



//let getFullText = mainPages.flatMap { el -> [String] in
//    
//    let full = el.flatMap { ell -> String in
//        
//        switch ell {
//        case let .text(tt): return tt
//        case let .image(img): return img
//        default: return ""
//        }
//    }
//    return full
//}
//print(getFullText.flatMap{ $0 })
//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)


let a = [1,2, 56, 3,4,56,7,8]

let b = a.split(56)
let c = a.split 
    { $0 == 56
    }


typealias Href = String
enum ElementType : CustomStringConvertible
{
    case text(String)
    case image(Href) 
    
    var description: String {
        switch self {
        case let .text(str): return "text: \(str)"
        case let .image(href) : return "image: \(href)"
        }
    }
}

let d = [ElementType.image("cover.jpg"), .text("Hello"), .image("hello.jpg"), .text("George"), .text("how are you?")]

let simpleSplit = 
    d.split { 
    switch $0 { 
    case .image: return true 
    default: return false } 
    }
.map { $0.flatMap { $0 } }

print(simpleSplit)

enum T { case br, int }
let arr = [T.int, T.br, T.int, T.int, T.br, T.int]

let split = arr.split { switch $0 { case .br: return true; default: return false } }
let pages = split.flatMap {$0}


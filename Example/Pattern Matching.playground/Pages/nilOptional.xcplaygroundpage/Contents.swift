//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"
var OptionalString : String? = Optional.init("Hello")!
var OptionalString2 : String? = nil

func nilString(str: String?) -> String
{
    if str == nil {
        return String()
        
    }else{
        return str!
    }
    
}

print(OptionalString)
nilString(OptionalString)
nilString(OptionalString2)


typealias Href = String


 indirect enum List {
    case head
    case tail(Int, List)
}

let emptyList = List.head
let a = List.tail(1, emptyList)
let b = List.tail(2, a)

func toArray(list: List) -> [Int] {
    switch list {
    case .head:
        return []
    case let .tail(num, tail):
        return toArray(tail) + [num]
    }
}

let c = toArray(b)


//let b = List.tail(2, List.tail(3, List.tail(4, List.head(1))))

enum ElementType
{
//    case container([ElementType])
    case text(String)
    case image(Href)
//    case empty
    
}

func classifier (element: AEXMLElement) -> ElementsType {
    
    switch element {
    case .container(children):
        for child in children{
            
            classifier(child)
        }
    default:
        return .empty
    }
}


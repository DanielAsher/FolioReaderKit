//: Playground - noun: a place where people can play

import Foundation

typealias Href = String

//enum WCEnum { 
//    case Wildcard 
//    case FromBeginning 
//    case ToEnd 
//    case Literal(Xml) 
//}
//
//func ~=(pattern: [WCEnum], value: [Xml]) -> Bool { 
//    var ctr = 0
//    for currentPattern in pattern { 
//        if ctr >= value.count || ctr < 0 { return false } 
//        let currentValue = value[ctr] 
//        switch currentPattern { 
//        case .Wildcard: ctr += 1
//        case .FromBeginning where ctr == 0: 
//            ctr = (value.count - pattern.count + 1) 
//        case .FromBeginning: return false
//        case .ToEnd: return true
//        case .Literal(let v): 
//            if v != currentValue { return false } 
//            else { ctr += 1 } 
//        } 
//    } 
//    return true
//}


indirect enum XmlGrammar {
    case head(XmlGrammar)
    case body(XmlGrammar)
    case row(XmlGrammar)
    case meta(name: String, value: String)
    case para(XmlGrammar)
    case text(String)
    case image(Href)
}





struct StoryPage : CustomStringConvertible {
    var image: String
    var paragraphs: [String]
    var description: String {
        return "image: \(image), paragraphs: \(paragraphs)"
    }
}

let xmlString1 = "<body><row><img src='google.com/image1'/><p>Hello</p></row></body>"

let xmlData1 = XmlGrammar.body(
//    [
    .row(.image("google.com/image1")) //,
//    .para(.text("Hello"))
//    ]
    )
//print(xmlData1)

func parse(str: String) -> XmlGrammar {
//    let xmlDoc = XE
    return .text("not implemented")
}

let xmlString2 = "<head><meta author='george'/></head>"
let xmlData2 = XmlGrammar.head(.meta(name: "author", value: "george"))
let xmlData = parse(xmlString2)

extension XmlGrammar {
    func toStoryPage() -> StoryPage? {
        switch self {
        case .body(.row(.image(let href))):
            print(href) // or create UIView or StoryPage
            return StoryPage(image: href, paragraphs: [])
        case .head(.meta(let author, let value)):
            print("author is \(value)") // update cover image with author name.
            return StoryPage(image: "", paragraphs: [author, value])
        default: print("No pattern matched")
        }
    return nil
    }
}


let storyPage1 = xmlData1.toStoryPage()
let storyPage2 = xmlData2.toStoryPage()



// Operators
//
infix operator =~= { }

func =~=(lhs: Int, rhs: Int) -> Bool {
    return abs(lhs - rhs) < 4
}

let isClose = 3 =~= 9



print("Finished 😀")
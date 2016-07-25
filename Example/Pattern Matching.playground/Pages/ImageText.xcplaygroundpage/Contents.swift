
import Foundation
import UIKit
import SpriteKit
//import RxSwift
//import RxCocoa
import XCPlayground


typealias Href = String

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

//let xmlString1 = " <body>
//                    <row>
//                        <img src='google.com/image1'/>
//                            <p>
//                                "Hello, my name is Ilmas,"
//                                <i>I</i>    
//                                "I used to play piono but I play guitar."
//                            </p>   
//                    </row>
//                    </body>"

let xmlString1 = "<body><row><img src='google.com/image1'/><p>\"Hello, my name is Ilmas,\"<i>I</i>\"I used to play piono but I play guitar.\"</p></row></body>"



let xmlData1 = XmlGrammar.body(
    //    [
    .row(.image("google.com/image1"))
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





let vc = UIViewController()

let sampleView = UIImageView(frame: CGRectMake(100,250,200,200))
let img = UIImage(named:"Icon-76")

sampleView.backgroundColor = UIColor.redColor()
sampleView.image = img
vc.view.addSubview(sampleView)

let sampleText = UITextField(frame: CGRectMake(100,50,200,200))

sampleText.font = UIFont.systemFontOfSize(15)
sampleText.borderStyle = UITextBorderStyle.RoundedRect
sampleText.keyboardType = UIKeyboardType.Default
sampleText.clearButtonMode = UITextFieldViewMode.WhileEditing;
sampleText.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
sampleText.backgroundColor = UIColor.greenColor()
sampleText.text = "hello"

vc.view.addSubview(sampleText)


XCPlaygroundPage.currentPage.liveView = vc





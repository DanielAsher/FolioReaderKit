//
//  TextImageViewController.swift
//  Example
//
//  Created by GEORGE QUENTIN on 01/07/2016.
//  Copyright © 2016 FolioReader. All rights reserved.
//

@testable import FolioReaderKit
import Foundation
import UIKit
import AEXML


class TextImageViewController: UIViewController {
 
    var currentSpinesIndex = 0
    var ePubIndex = 2
    
    let xPos = 20
    var width = 0
    var height = 0
    
    var numberOfSpines = 0
    var pageNumber = 0
    var allPages = 0
    
    var topText = UITextView()
    var img = UIImageView()
    var textView = UITextView()
    
    var bodyChildrensNames : [String] = []
    
    var subject: FREpubParser!
    var textsInPara : [String] = []
    
    var ePubsCollection : [String] = [
        "The Tale of Johnny Town-Mouse",
        "The Tailor of Gloucester",
        "The Tale of Peter Rabbit - Beatrix Potter",
    ]
 
    enum ElementType : CustomStringConvertible {
        case text(String)
        case image(String) // typealias Href
        case firstPageMarker
        case pagebreak
        
        var description: String {
            switch self {
            case let .text(str): return "\(str)"
            case let .image(href) : return "\(href)"
            case .firstPageMarker: return "firstPage"
            case .pagebreak: return "pagebreak: "
                
            }
        }
    }
    
    
    override func viewDidLoad() 
    {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
        width = Int(self.view.frame.size.width) - 50
        height = Int(self.view.frame.size.width/1.5)
        
        topText = UITextView(frame: CGRect(x: xPos, y: 50, width: width , height: 50))
        topText.clipsToBounds = false
        topText.font = topText.font?.fontWithSize(12)
        topText.editable = false
        self.view.addSubview(topText)
        
        
        img = UIImageView(frame: CGRect(x: xPos, y: Int(topText.frame.maxY), width: width, height: height))
        self.view.insertSubview(img, atIndex: 0)
        textView = UITextView(frame: CGRect(x: xPos, y: Int(img.frame.maxY), width: width, height: height))
        textView.clipsToBounds = true
        textView.editable = false
        textView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        self.view.addSubview(textView)
        
        let tapPG = UITapGestureRecognizer(target: self, action: #selector(TextImageViewController.tapPages(_:)))
        textView.addGestureRecognizer(tapPG)
        textView.userInteractionEnabled  = true
    
        
        createBook(ePubsCollection[ePubIndex],pageNumber: 0)
    }
    
    
    func createBook(ePub: String, pageNumber: Int){
        
        let path = NSBundle(forClass: self.dynamicType).pathForResource(ePub, ofType: "epub")!
        subject = FREpubParser()
        subject.readEpub(epubPath: path)
        
        let book = subject.book
        //print("bood name ==== \(book.title())")
        
        let spines = book.spine.spineReferences
        numberOfSpines = spines.count
        
        let resource = spines[currentSpinesIndex].resource
        let opfData = try? NSData(contentsOfFile: resource.fullHref, options: .DataReadingMappedAlways)
        let xmlDoc = try? AEXMLDocument(xmlData: opfData!)
       
        let htmRef = resource.href
        guard 
            let cover = book.coverImage.fullHref,//nilFRResourse(book.coverImage),
            let title = book.metadata.titles.first,
            let author = nilString(book.metadata.creators.first?.name),
            let headCount = xmlDoc?.root["head"].all?.count,
            let bodyCount = xmlDoc?.root["body"].all?.count,
            let head = xmlDoc?.root["head"],
            let body = xmlDoc?.root["body"],
            let bodyChildrens = xmlDoc?.root["body"].children.count
            //let image = body.children[indexAdd]["img"].attributes["src"]
        else { return }
        
        func classify(element: AEXMLElement) -> [ElementType] {
            switch (element.children.count, element.name) {
            case (0, _):
                if let href = element.attributes["src"] where element.name == "img" {
                    return [.image(href)]
                } else if element.name == "hr" {
                    return [.pagebreak]
                }
                else if let textContent = element.value {
                    return [.text(textContent)]
                } else {
                    return []//[.empty]
                }
            case (_, "table"):
                return [.pagebreak] + element.children.flatMap(classify)
            case _:
                return element.children.flatMap(classify)
            }
        }
        
        let allResults = classify(body)
        //allResults.forEach { print($0) }
        
        let pages = allResults.split { 
            switch $0 { 
            case ElementType.pagebreak: return true
            default: return false } 
        }.map { $0.flatMap { $0 } }
       // pages.forEach{ print($0) }
        //print("pages ======== \(pages.count)") 
        
     
        var images = pages.map { //print($0)
            
            return $0.filter { (element) -> Bool in
                
                switch element { 
                case .image(_): //ElementType.image:
                    return true
                default: 
                    return false
                } 
            }
            
        }.filter { $0.isEmpty == false }
        
        
        images.insert([ElementType.image("newImage")], atIndex: 1)
        //images.forEach{ print($0) }
        
        var paragraphs = pages.dropFirst(2).map { 
            return $0.filter { (element) -> Bool in
                
                switch element { 
                case .text(_): //ElementType.text(test):
                    return true
                default: 
                    return false
                } 
            }
        }.filter { $0.isEmpty == false }
        paragraphs.insert([ElementType.text("\(title) by \(author)")], atIndex: 0)
        //paragraphs.forEach { print($0)  }   
            
        if images.count == paragraphs.count {
           allPages = paragraphs.count
        }
       // print("pages ======== \(pages.count), imagess ===== \(images.count),   paragraphs ===== \(paragraphs.count)") 
        
        
        let imageDescription = images[pageNumber].lazy.flatMap { $0 }
        let pageDescription = paragraphs[pageNumber].lazy.flatMap { $0 } 
            
        let page = pageDescription.reduce("") { acc, x in
                let res = acc + " " + x.description
                return res
        }
        guard let image = imageDescription.first?.description else { return }
        let storyPage = StoryPage(image: resource.basePath() + "/" + image, paragraph: page)
        
        textView.text = storyPage.paragraph
        textView.font = textView.font?.fontWithSize(12)
        img.image = UIImage(contentsOfFile: storyPage.image) // SetImage(cover)
        topText.text = "TITLE : \(title) by \(author)" 
        
    }
    

    
    func tapPages(tap: UITapGestureRecognizer) {
        
        //let location = tap.locationInView(self.view)
       // let text = tap.view as! UIButton
       // text.backgroundColor = UIColor.randomColor()
        //print(location )
        pageNumber += 1
        if pageNumber > allPages-1 {
            
            pageNumber = 0
        }
        print(pageNumber)
        createBook(ePubsCollection[ePubIndex], pageNumber: pageNumber)
        
//        bodyElementIndex += 1
//        if (bodyElementIndex > bodyChildrensNames.count-1)
//        {
//            bodyElementIndex = 0
//        }
        
//        print("body child ====== \(bodyElementIndex) ==== number of children \(bodyChildrensNames.count) ")
    }
    
    
    
    func nilString(str: String?) -> String?
    {
        if str == nil {
            return String()
            
        }else{
            return str
        }
        
    }
    
    func nilFRResourse(res: FRResource?) -> String?
    {
        
        if res == nil {
            return String()
            
        }else{
            return res?.fullHref
        }
        
    }
    
    func SetImage(image: String) -> UIImage {
        
        if image != "" {
            return UIImage(named:image)!
        }else{
            return UIImage(named:"Brucy")!
        }
        
    }
    
    
        
        //let a = xmlDoc!.root["body"].children.filter { $0.name == "table" }
        
//        let intIndex = Int.random(0, max: xmlDoc!.root["body"]["table"].count - 1)
//        let index = book.resources.resources.startIndex.advancedBy(intIndex)
//        let imag = book.resources.resources.values[index].fullHref
//        print("type1 =====", imag)
//        
//        //print("type2 ====== ", resource.basePath(), imageFilename)
//        
//       let pages = xmlDoc!.root["body"]["table"].all!.map { table -> StoryPage in  
//            
//            guard 
//                let basePath = resource.basePath(),    
//                let imageSource = table["tbody"]["tr"].children[0]["img"].attributes["src"],
//                let paragraphs = table["tbody"]["tr"].children[safe: 1]?["p"].all
//            else { return StoryPage() }
//            
//            let imageFilename = "\(basePath)/\(imageSource)"
//            for para in paragraphs {
//                textsInPara.append(para.stringValue)
//            }
//            let text = textsInPara.myJoinWithSeperator("\n\n")
//        
//            return StoryPage(image: imageFilename, paragraph: text) 
//        }
//        let currentPage = pages[intIndex]
//        

    
    
    //        pages.forEach { print($0)
    ////            $0.forEach {
    ////                switch $0 { 
    ////                case let .text(t): 
    ////                    print("\"\(t)\"")
    ////                default: print($0) 
    ////                } 
    ////            }
    //        }
    
    
    //        let getImages = 
    //            allResults.split { 
    //                
    //            switch $0 { 
    //                case .image: return false 
    //                default: return true } 
    //            }
    //                .map { $0.flatMap { $0 } }
    //        
    //        let getText = 
    //            allResults.split { 
    //                
    //                switch $0 { 
    //                case .text: return true 
    //                default: return false } 
    //                }
    //                .map { $0.flatMap { $0 } }
    //        
    //print("text ===== \(getText),  images ===== \(getImages.count) ")
    
    
    
    //        let p = pages.flatMap { (element: ElementType) -> StoryPage in  
    //            
    //            let imageFilename = .image
    //            let text = .text
    //            return StoryPage(image: imageFilename, paragraph: text) 
    //        }
    //        
    
    
    //        let p = pages.flatMap { (element: [ElementType]) -> StoryPage in
    //
    //            
    //            switch element {
    //            case let [.image(href)]:
    //                return resource.basePath() + "/" + href
    //            default: 
    //                return nil
    //            }
    //            
    //            return StoryPage(image: imageFilename, paragraph: text) 
    //        }
    
    //print(body.children[66].xmlStringCompact)
    //print(body.children[66]["a"].attributes["id"]?.xmlEscaped  ,body.children[66].children[0].xmlStringCompact ,body.children[66].children.count)
    //bodyElementIndex
//    let words = body.children[bodyElementIndex].stringValue
//    textView.text = words
//    if let firstImage = imagehRefs.first {
//        img.image = UIImage(contentsOfFile: firstImage) //SetImage(cover)
//    }
    //        topText.text = "TITLE : \(title) by \(author)" 
    
    
    // bodyChildrensNames = body.children.flatMap { $0.name }
    //let allResults = classify(body)
    // print(allResults.count)
    //allResults.forEach { print($0) }
        
        
        //        let imagehRefs = allResults.flatMap { (element: ElementType) -> String? in
        //           
        //            switch element {
        //            case let .image(href):
        //                return resource.basePath() + "/" + href
        //            default: 
        //                return nil
        //            }
        //        }
    
    //        
    //        pages.forEach { //print($0)
    //            
    //                
    ////            print( $0.filter { (element : ElementType) -> Bool in
    ////                
    ////                switch element { 
    ////                case ElementType.image: return true
    ////                default: return false 
    ////                } 
    ////            })
    //            let images = $0.filter { (element) -> Bool in
    //                
    //                switch element { 
    //                case ElementType.image:
    //                   return true
    //                default: return false
    //                } 
    //            }
    //            if images.isEmpty == false { print(images) }
    //   
    //        }

    
    
    
    
}
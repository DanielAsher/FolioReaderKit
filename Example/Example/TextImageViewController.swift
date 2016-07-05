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
 
    var bodyElementIndex = 0 
    var ePubIndex = 0
    
    let xPos = 5
    let width = 350
    let width2 = 50
    let height = 300
    
    var currentSpinesIndex = 0
    var numberOfSpines = 0
    
    var ePubText = UITextView()
    var topText = UITextView()
    var img = UIImageView()
    var textView = UITextView()
    var coverButton = UIButton()
    var pagesButton = UIButton()
    
    var bodyChildrensNames : [String] = []
    
    var subject: FREpubParser!
    var textsInPara : [String] = []
    
    var ePubsCollection : [String] = [
        "The Adventures Of Sherlock Holmes - Adventure I",
        "The Silver Chair",
        "Moby Dick",
        "The Tale of Peter Rabbit - Beatrix Potter",
        "A Trip to Cuba",
        "Across the Cameroons",
        "Antarctic Penguins",
        "Cocoa and Chocolate",
        "From Pole to Pole",
        "History of Beasts",
        "In the Heart of Africa",
        "Introduction of the Locomotive Safety Truck",
        "Mozart The Man and the Artist, as Revealed in His Own Words",
        "Poems on Travel",
        "Shakespeare and Music",
        "Textiles, for Commercial, Industrial, and Domestic Arts Schools",
        "The 2010 CIA World Factbook by United States",
        "The Story of an Ostrich",
        "The Woodpeckers",
        "Travels in West Africa"
        ]
    
    var ePubInAlphabeticalOrder : [String] = []
    
    override func viewDidLoad() 
    {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
       
        ePubInAlphabeticalOrder = ePubsCollection.sort { $0 < $1 }
        //print(ePubInAlphabeticalOrder.flatMap { $0 }, ePubInAlphabeticalOrder.count)
        
        
        topText = UITextView(frame: CGRect(x: xPos, y: 40, width: width+51, height: 60))
        topText.clipsToBounds = false
        topText.font = topText.font?.fontWithSize(12)
        topText.editable = false
        self.view.addSubview(topText)
        
        coverButton = UIButton(frame: CGRect(x: 356, y: 100, width: 50, height: height))
        coverButton.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(coverButton)
        
        
        img = UIImageView(frame: CGRect(x: xPos, y: 100, width: width, height: height))
        //img.image = UIImage(named:currentPage.image)
        self.view.insertSubview(img, atIndex: 0)
        
        textView = UITextView(frame: CGRect(x: xPos, y: 400, width: width, height: height))
        textView.clipsToBounds = true
        textView.font = textView.font?.fontWithSize(25)
        textView.editable = false
        textView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        self.view.addSubview(textView)
        
        pagesButton = UIButton(frame: CGRect(x: 356, y: 400, width: 50, height: height))
        pagesButton.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(pagesButton)
        
        ePubText = UITextView(frame: CGRect(x: xPos, y: 700, width: width+51, height: 50))
        ePubText.clipsToBounds = false
        ePubText.font = topText.font?.fontWithSize(10)
        ePubText.editable = false
        self.view.addSubview(ePubText)
        
        
        let tapC = UITapGestureRecognizer(target: self, action: #selector(TextImageViewController.tapCover(_:)))
        coverButton.addGestureRecognizer(tapC)
        coverButton.userInteractionEnabled  = true
        
        let tapPG = UITapGestureRecognizer(target: self, action: #selector(TextImageViewController.tapPages(_:)))
        pagesButton.addGestureRecognizer(tapPG)
        pagesButton.userInteractionEnabled  = true
        
        let tapE = UITapGestureRecognizer(target: self, action: #selector(TextImageViewController.tapEpub(_:)))
        ePubText.addGestureRecognizer(tapE)
        ePubText.userInteractionEnabled  = true
        
    }
    
    enum ElementType : CustomStringConvertible {
        case text(String)
        case image(String) // typealias Href
        case empty
        
        var description: String {
            switch self {
            case let .text(str): return "text: \(str)"
            case let .image(href) : return "image: \(href)"
            case .empty: return "empty"
            }
        }
    }
    
    func createBook(ePub: String){
        
        
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
            let cover = nilFRResourse(book.coverImage),
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
            switch element.children.count {
            case 0:
                if let href = element.attributes["src"] where element.name == "img" {
                    return [.image(href)]
                } else if let textContent = element.value {
                    return [.text(textContent)]
                }else if let textValue = Optional<String>(element.stringValue) {
                    return [.text(textValue)]
                } else {
                    return [.empty]
                }
            case _:
                return element.children.flatMap(classify)
            }
        }
        
        
        bodyChildrensNames = body.children.flatMap { $0.name }
        let allResults = classify(body)
        allResults.forEach { print($0) }
        
        let imagehRefs = allResults.flatMap { (element: ElementType) -> String? in
            switch element {
            case let .image(href):
                return resource.basePath() + "/" + href
            default: 
                return nil
            }
        }
        
//bodyElementIndex
        let words = body.children[66].stringValue
        
        //print(body.children[66]["a"].xmlString    ,body.children[66].children.count)

        textView.text = words
        if let firstImage = imagehRefs.first {
            img.image = UIImage(contentsOfFile: firstImage) //SetImage(cover)
        }
//        topText.text = "TITLE : \(title) by \(author)" 
    }
    
    func tapEpub(tap: UITapGestureRecognizer) {
        
        //let location = tap.locationInView(self.view)
//        let epub = tap.view as! UITextView
//        epub.backgroundColor = UIColor.randomColor()
//        //print(location )
//       
//        bodyElementIndex = 0
//        currentSpinesIndex = 0
//        
//        ePubIndex += 1
//        if (ePubIndex > ePubInAlphabeticalOrder.count-1)
//        {
//            ePubIndex = 0
//        }
//        ePubText.text = "EPUB: \(ePubInAlphabeticalOrder[ePubIndex])"
//        createBook(ePubInAlphabeticalOrder[ePubIndex])
//        
//        print("NEW EPUB =================================== \(ePubIndex)")
    }
    
    func tapCover(tap: UITapGestureRecognizer) {
        
//        //let location = tap.locationInView(self.view)
//        let cover = tap.view as! UIButton
//        cover.backgroundColor = UIColor.randomColor()
//        //print(location )
//        
//        bodyElementIndex = 0
//        currentSpinesIndex += 1
//        if currentSpinesIndex > numberOfSpines-1 {
//            currentSpinesIndex = 0
//        }
//        createBook(ePubInAlphabeticalOrder[ePubIndex])
//        
//        print("NEW HTML =================================== \(currentSpinesIndex)")
        
    }
    
    func tapPages(tap: UITapGestureRecognizer) {
        
        //let location = tap.locationInView(self.view)
        let text = tap.view as! UIButton
        text.backgroundColor = UIColor.randomColor()
        //print(location )
        
        createBook(ePubInAlphabeticalOrder[3])//ePubIndex])
        bodyElementIndex += 1
        if (bodyElementIndex > bodyChildrensNames.count-1)
        {
            bodyElementIndex = 0
        }
        
        print("body child ====== \(bodyElementIndex) ==== number of children \(bodyChildrensNames.count) ")
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
        //        if let cover = book.coverImage.fullHref {
        //            print("yess")
        //            
        //        }else{
        //            return
        //        }
        
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
    func GetNumberOfChildren(element: AEXMLElement) -> Int {
        
        return element.children.count
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


        
        
}
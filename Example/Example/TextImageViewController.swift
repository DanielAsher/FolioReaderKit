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
 
    let xPos = 5
    let width = 400
    let height = 300
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
       
        let path = NSBundle(forClass: self.dynamicType).pathForResource(ePubsCollection[12], ofType: "epub")!
        subject = FREpubParser()
        subject.readEpub(epubPath: path)
        
        let book = subject.book
        let resource = book.spine.spineReferences[0].resource
//        let opfData = try? NSData(contentsOfFile: resource.fullHref, options: .DataReadingMappedAlways)
//        let xmlDoc = try? AEXMLDocument(xmlData: opfData!)
       
       // print("tables contents in html ========== ", book.tableOfContents.count)
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
//        
//        guard 
//            //let cover = book.coverImage.fullHref,
//            let title = book.metadata.titles.first,
//            let author = book.metadata.creators.first?.name
//        else { return }
//        
//        let topText = UITextView(frame: CGRect(x: xPos, y: 40, width: width, height: 40))
//        topText.clipsToBounds = false
//        topText.text = "TITLE : \(title) by \(author)" 
//        topText.font = topText.font?.fontWithSize(15)
//        topText.editable = false
//        self.view.addSubview(topText)
//        
//        
//        let img = UIImageView(frame: CGRect(x: xPos, y: 100, width: width, height: height))
//        img.image = UIImage(named:currentPage.image)
//        self.view.insertSubview(img, atIndex: 0)
//        
//        
//        let textView = UITextView(frame: CGRect(x: xPos, y: 400, width: width, height: height))
//        textView.clipsToBounds = true
//        textView.text = currentPage.paragraph
//        textView.font = textView.font?.fontWithSize(16)
//        textView.editable = false
//        textView.backgroundColor = UIColor.randomColor()
//        textView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
//        self.view.addSubview(textView)
//        
//    
//        let pageText = UITextView(frame: CGRect(x: 356, y: 700, width: 50, height: 40))
//        pageText.clipsToBounds = false
//        pageText.text = "p.\(intIndex + 1)"
//        pageText.font = pageText.font?.fontWithSize(15)
//        pageText.editable = false
//        self.view.addSubview(pageText)
        
        
        
    }
    
    
}
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
 
    let xPos = 6
    let width = 400
    let height = 300
    
    var subject: FREpubParser!
    var textsInPara : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
       
        let path = NSBundle(forClass: self.dynamicType).pathForResource("The Tale of Peter Rabbit - Beatrix Potter", ofType: "epub")!
        subject = FREpubParser()
        subject.readEpub(epubPath: path)
        
        let book = subject.book
        let resource = book.spine.spineReferences[0].resource
        let opfData = try? NSData(contentsOfFile: resource.fullHref, options: .DataReadingMappedAlways)
        var xmlDoc = try? AEXMLDocument(xmlData: opfData!)
       
       // print("tables contents in html ========== ", book.tableOfContents.count)
        //let a = xmlDoc!.root["body"].children.filter { $0.name == "table" }
        
        let intIndex = Int.random(0, max: xmlDoc!.root["body"]["table"].count - 1)
        let index = book.resources.resources.startIndex.advancedBy(intIndex)
        let imag = book.resources.resources.values[index].fullHref
        print("type1 =====", imag)
        
        guard 
        let basePath = resource.basePath(),    
        let tableElements = xmlDoc!.root["body"]["table"].all,
        //let cover = book.coverImage.fullHref,
        let title = book.metadata.titles.first,
        let author = book.metadata.creators.first?.name,
        let imageSource = tableElements[intIndex]["tbody"]["tr"].children[0]["img"].attributes["src"],
        let paragraphs = tableElements[intIndex]["tbody"]["tr"].children[safe: 1]?["p"].all else { return }
       
        let imageFilename = "\(basePath)/\(imageSource)"
        //print("type2 ====== ", resource.basePath(), imageFilename)
        
        for para in paragraphs {
            textsInPara.append(para.stringValue)
        }
        let text = textsInPara.myJoinWithSeperator("\n\n")
        
        
        let topText = UITextView(frame: CGRect(x: xPos, y: 40, width: width, height: 40))
        topText.clipsToBounds = false
        topText.text = "TITLE : \(title) by \(author)" 
        topText.font = topText.font?.fontWithSize(15)
        topText.editable = false
        self.view.addSubview(topText)
        
        let img = UIImageView(frame: CGRect(x: xPos, y: 100, width: width, height: height))
        img.image = UIImage(named:imageFilename)
        self.view.insertSubview(img, atIndex: 0)
        
        
        let textView = UITextView(frame: CGRect(x: xPos, y: 400, width: width, height: height))
        textView.clipsToBounds = false
        textView.text = text
        textView.font = textView.font?.fontWithSize(20)
        textView.editable = false
        self.view.addSubview(textView)
        
    
        let pageText = UITextView(frame: CGRect(x: 355, y: 700, width: 50, height: 40))
        pageText.clipsToBounds = false
        pageText.text = "p.\(intIndex + 1)"
        pageText.font = pageText.font?.fontWithSize(15)
        pageText.editable = false
        self.view.addSubview(pageText)
        
    }
    
    
}
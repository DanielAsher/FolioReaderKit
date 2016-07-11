//
//  FolioReaderTests.swift
//  FolioReaderTests
//
//  Created by Brandon Kobilansky on 1/25/16.
//  Copyright © 2016 FolioReader. All rights reserved.
//

@testable import FolioReaderKit

import Quick
import Nimble
import AEXML

struct StoryPages {
    var image: String = ""
    var paragraph: String = ""
}


class FolioReaderTests: QuickSpec {
    
    var ePubsCollection : [String] = [
        "The Tale of Johnny Town-Mouse",
        "The Tailor of Gloucester",
        "The Tale of Peter Rabbit - Beatrix Potter",
        ]
   
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
    
    enum ElementType: CustomStringConvertible {
        case text(String)
        case image(String) // typealias Href
        case firstPageMarker
        case pagebreak
        
        var description: String {
            switch self {
            case let .text(str): return "\(str)"
            case let .image(href) : return "\(href)"
            case .firstPageMarker: return ""//"firstPage"
            case .pagebreak: return ""//"pagebreak: "
                
            }
        }
    }
    
    
    override func spec() {
        
        context("epub parsing") {
            var subject: FREpubParser!

            beforeEach {
                let path = NSBundle(forClass: self.dynamicType).pathForResource(self.ePubsCollection[2], ofType: "epub")!
                subject = FREpubParser()
                subject.readEpub(epubPath: path)
            }

            it("correctly parses a properly formatted document") {
                
                let book = subject.book
                //print("bood name ==== \(book.title())")
                
                let spines = book.spine.spineReferences.forEach { spine in
                    
                //print(spines.count)
                let resource = spine.resource             
                let opfData = try? NSData(contentsOfFile: resource.fullHref, options: .DataReadingMappedAlways)
                
                var xmlDoc : AEXMLDocument?
                
                do {
                    xmlDoc = try AEXMLDocument(xmlData: opfData!)
                    
                } catch{
                    XCTAssert(false, "xml parsing exception")
                }
                
                
                let htmRef = resource.href
                guard 
                    let cover = self.nilFRResourse(book.coverImage),
                    let title = book.metadata.titles.first,
                    let author = self.nilString(book.metadata.creators.first?.name),
                    let headCount = xmlDoc?.root["head"].all?.count,
                    let bodyCount = xmlDoc?.root["body"].all?.count,
                    let head = xmlDoc?.root["head"],
                    let body = xmlDoc?.root["body"],
                    let bodyChildrens = xmlDoc?.root["body"].children.count
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
                //pages.map { print($0)}
               // print("pages ======== \(pages.count)") 
                
                let imagesRef = pages.map { //print($0)
                    
                    return $0.filter { (element) -> Bool in
                        
                        switch element { 
                        case let .image(img): //ElementType.image:
                            return true
                        default: 
                            return false
                        } 
                    }
                    
                }.filter { $0.isEmpty == false }
                //imagesRef.forEach{ print($0.count) }
                
                let paragraphs = pages.map { 
                    
                    return $0.filter { (element) -> Bool in
                        
                        switch element { 
                        case let .text(tex): //ElementType.text(test):
                            return true
                        default: 
                            return false
                        } 
                    }
                }.filter { $0.isEmpty == false }
                //para.forEach { print($0)  }   
                    
            //print("pages ======== \(pages.count), imagess ===== \(imagesRef.count),   paragraphs ===== \(paragraphs.count)") 
                    
                let imageDescription = imagesRef[0].lazy.flatMap { $0 }
                let pageDescription = paragraphs[0].lazy.flatMap { $0 } 
                
                let currentPage = pageDescription.reduce("") { acc, x in
                    let res = acc + " " + x.description
                    return res
                }
                    
                
            XCTAssertNil(cover, "is there a cover")//check if there is a cover
                    
            XCTAssertEqual(title,  "The Tale of Peter Rabbit - Beatrix Potter")// check if the title is
                    
            XCTAssertLessThan(pages.count, 30) // check that the number of pages is less than
            XCTAssertEqual(pages.count, 29) // check if the number of pages is less equal to
              
            
            XCTAssert(author, "is there a an author")//check if there is a author name
            XCTAssertEqual(author,  "Me") // check the author name
           
                    
                    
                    
//            func GetStoryPage(images images: [[ElementType]], pages: [[ElementType]],  pageNumber: Int) -> StoryPages {
//                 
//                let imageDescription = images[pageNumber].lazy.flatMap { $0 }
//                let pageDescription = pages[pageNumber].lazy.flatMap { $0 } 
//                    
//                let page = pageDescription.reduce("") { acc, x in
//                    let res = acc + x.description
//                    return res
//                }
//                
//                guard 
//                    let image = imageDescription.first?.description
//                else { return StoryPages() }
//                
//                
//                return StoryPages(image: resource.basePath() + "/" + image, paragraph: page) 
//            }
//            
//            print("This is a Page   =======   \(GetStoryPage(images: imagesRef, pages: paragraphs,pageNumber: 0))")
//           
                
                
            }
                
                // expect(pages.count).to(equal(29))
               // print("pages ======== \(pages.count)") 
                
            
                

            //      //let storyBook = getStoryBookFromXML(book: subject.book, xmlDoc: xmlDoc) // Replace this with a generated version from xml.
//                let firstWord = pages.first?.paragraph.componentsSeparatedByString(" ").first
                
 
  ////          let firstWordOnLastPage = pages.last?.componentsSeparatedByString(" ").first
  ////          expect(firstWordOnLastPage).to(equal("BUT"))

                
//                expect(firstWord).to(equal("ONCE"))
//                
//                expect(storyBook.pages.count).to(equal(23))
                
   
                
//                expect(storyBook.title).to(equal("The Tale of Peter Rabbit"))
                
//                expect(storyBook.pages.count).to(equal(20))

//                expect(subject.book.tableOfContents.count).to(equal(2))
                
         
            }
        
            it("finds primary html resource") {

            }
            
        }
            
    }
}













//    func getStoryBookFromXML(book book: FRBook, xmlDoc: AEXMLDocument?) -> StoryBook {
        
        // guard let xmlDoc = xmlDoc else { return StoryBook() }
        
        //print("html show all ===== ",xmlDoc.root.xmlString) // should print "all things in html"
        //                    print("html ===== ",xmlDoc.root.name) // should print "html"
        //                    
        //                    if let title = xmlDoc.root["head"]["title"].value {
        //                        print("title  ====== ", title)
        //                    }
        //                    
        //                    for string in xmlDoc.root["body"]["h2"].all! 
        //                    {
        //                        print(string.attributes["id"])
        //                    }
        //                    print(xmlDoc.root["body"]["h2"].first?.xmlString)
        
        
        
        
        //print(tableElements.)
        //                    guard 
        //                        let tableElements = xmlDoc.root["body"]["table"].all,
        //                        let cover = book.coverImage.fullHref,
        //                        let title = book.metadata.titles.first,
        //                        let author = book.metadata.creators.first?.name,
        //                        let imageInTable = tableElements[0]["tbody"]["tr"].children[0]["img"].attributes["src"],
        //                        let textInTable = tableElements[0]["tbody"]["tr"].children[safe: 1]?["p"].stringValue
        //                        else { return StoryBook() }
        //                    
        //                    print("table Elements amount ====== ", tableElements.count)
        //                    print("Title ====== ",title)
        //                    print("author ====== ",author)
        //                    
        //                    print("number of elements in Table ====== ", tableElements[0]["tbody"]["tr"]["td"].count)
        //                    
        //                    print("image in Table ====== ", imageInTable)
        //                    print("text in table ====== ", textInTable)
        //                    
        //                
        //                    
        //                    let storyPage = StoryPage(image: imageInTable, paragraph: textInTable)
        //                    
        //                    //return StoryBook()
        //                    return StoryBook(cover: cover, title: title, author: author, pages: [storyPage])
//}



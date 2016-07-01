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

class FolioReaderTests: QuickSpec {
    
    override func spec() {
        
        context("epub parsing") {
            var subject: FREpubParser!

            beforeEach {
                let path = NSBundle(forClass: self.dynamicType).pathForResource("The Tale of Peter Rabbit - Beatrix Potter", ofType: "epub")!
                subject = FREpubParser()
                subject.readEpub(epubPath: path)
            }

            it("correctly parses a properly formatted document") {
                let book = subject.book
                let resource = book.spine.spineReferences[0].resource
//                var html = try? String(contentsOfFile: resource.fullHref, encoding: NSUTF8StringEncoding)
                
                
                let opfData = try? NSData(contentsOfFile: resource.fullHref, options: .DataReadingMappedAlways)
                
                var xmlDoc : AEXMLDocument?
                
                do {
                    xmlDoc = try AEXMLDocument(xmlData: opfData!)
                    
                } catch{
                    XCTAssert(false, "xml parsing exception")
                }
                
//                var images = 
                print("tables contents in html ========== ", book.tableOfContents.count)
                
                
                func getStoryBookFromXML(book book: FRBook, xmlDoc: AEXMLDocument?) -> StoryBook {
                    
                    guard let xmlDoc = xmlDoc else { return StoryBook() }
                    
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
                    guard 
                        let tableElements = xmlDoc.root["body"]["table"].all,
                        let cover = book.coverImage.fullHref,
                        let title = book.metadata.titles.first,
                        let author = book.metadata.creators.first?.name,
                        let imageInTable = tableElements[0]["tbody"]["tr"].children[0]["img"].attributes["src"],
                        let textInTable = tableElements[0]["tbody"]["tr"].children[safe: 1]?["p"].stringValue
                        else { return StoryBook() }
                    
                    print("table Elements amount ====== ", tableElements.count)
                    print("Title ====== ",title)
                    print("author ====== ",author)
                    
                    print("number of elements in Table ====== ", tableElements[0]["tbody"]["tr"]["td"].count)
                    
                    print("image in Table ====== ", imageInTable)
                    print("text in table ====== ", textInTable)
                    
                
                    
                    let storyPage = StoryPage(image: imageInTable, paragraph: textInTable)
                    
                    //return StoryBook()
                    return StoryBook(cover: cover, title: title, author: author, pages: [storyPage])
                }
                
                
                let storyBook = getStoryBookFromXML(book: subject.book, xmlDoc: xmlDoc) // Replace this with a generated version from xml.
                
                print("book ", storyBook)
                
                
                
                
            }
            
            
            
            
            
            
            
            
                
//                do {
//                    xmlDoc = try AEXMLDocument(xmlData: opfData!)
//                    
//                    guard let tableElements = xmlDoc?.root["body"]["table"].all
//                        else { return }
//                    
//                    for table in tableElements {
//                        
//                        print(table.xmlString)
//                        
//                        if let cellspacingStr = table.attributes["cellspacing"],
//                            let cellspacing = Int(cellspacingStr)
//                        {
//                            print("cellspacing:", cellspacing)
//                        }
//                    }
//                } catch {
//                    XCTAssert(false, "xml parsing exception")
//                }
                
                
                
//                expect(storyBook.title).to(equal("The Tale of Peter Rabbit"))
                
//                expect(storyBook.pages.count).to(equal(20))

//                expect(subject.book.tableOfContents.count).to(equal(2))
                
//            }
            
            it("finds primary html resource") {
//                subject.book.re
            }
        }
    }
}

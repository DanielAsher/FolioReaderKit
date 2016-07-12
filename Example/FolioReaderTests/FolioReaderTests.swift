//
//  FolioReaderTests.swift
//  FolioReaderTests
//
//  Created by Brandon Kobilansky on 1/25/16.
//  Copyright © 2016 FolioReader. All rights reserved.
//

@testable import Example
@testable import FolioReaderKit
import Quick
import Nimble
import AEXML



class FolioReaderTests: QuickSpec {
    
    var ePubsCollection : [String] = [
        "The Tale of Johnny Town-Mouse",
        "The Tailor of Gloucester",
        "The Tale of Peter Rabbit - Beatrix Potter",
        ]
   
    
    
    override func spec() {
        
        describe("epub parsing") {
            
            it("correctly parses BP - The Tale of Peter Rabbit") 
            {
                
                    
//                XCTAssertEqual(book.coverImage.href, "@public@vhost@g@gutenberg@html@files@14838@14838-h@images@peter02.gif")//test pass:
//                XCTAssertEqual(cover, "is there a cover")//test fail: check if there is a cover
//                    
//                XCTAssertEqual(title,  "The Tale of Peter Rabbit - Beatrix Potter")// check if the title is
//                
//                XCTAssertEqual(author, "is there a an author")//test fail: check if there is a author name
//                XCTAssertEqual(author,  "Beatrix Potter") //test pass: check the author name
//                    
//                XCTAssertLessThan(pages.count, 30) // check that the number of pages is less than
//                XCTAssertEqual(pages.count, 29) // check if the number of pages is less equal to
//  
//                XCTAssertEqual(pages.count, 29) // check if the number of pages is less equal to
//                
//                XCTAssertEqual(imagesRef.count, 28) // check if the number of pages is less equal to
//                XCTAssertEqual(paragraphs.count, 28) // check if the number of pages is less equal to
//                
//                XCTAssertEqual(paragraphs.count, imagesRef.count) // check if the number of pages is less equal to
//                
//                
//                XCTAssertEqual(firstPage, " Hello george")
//                XCTAssertEqual(firstPage, " Once upon a time there were four little Rabbits, and their names were— Flopsy, Mopsy, Cotton-tail,") //test pass:
//                    
//                XCTAssertEqual(lastPage, " But Flopsy, Mopsy, and Cotton-tail had bread and milk and blackberries for supper. THE END")// test pass:
//                    
                    
             //   }
            }
        
            //fit is a focus test 
            fit("EpubStoryReader correctly creates StoryBook from 'The Tale of Peter Rabbit'") {
                
                let epubStoryReader = EpubStoryReader()
                let epubURL = NSBundle(forClass: self.dynamicType).URLForResource(self.ePubsCollection[2], withExtension: "epub")!
                                
                do {
                    
                    let storyBook = try epubStoryReader.read(epubURL) 
//                    print(storyBook)
//                    XCTAssertEqual(storyBook.info.cover, "@public@vhost@g@gutenberg@html@files@14838@14838-h@images@peter02.gif")//test fail: check if there is a cover
//                        
//                    XCTAssertEqual(title,  "The Tale of Peter Rabbit - Beatrix Potter")// check if the title is
//                    
//                    XCTAssertEqual(author, "is there a an author")//test fail: check if there is a author name
//                    XCTAssertEqual(author,  "Beatrix Potter") //test pass: check the author name
//                    expect(storyBook.pages.count) == 29
                }
                catch let err {
                    XCTAssert(false, "\(err)")
                    
                    print(err)
                }
                
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


//            }

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




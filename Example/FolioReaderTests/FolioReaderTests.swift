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
        "The Tale of Peter Rabbit - Beatrix Potter",
        "The Tailor of Gloucester",
        "The Tale of Johnny Town-Mouse"
        ]
   
    override func spec() {
        
        describe("epub parsing") 
        {
            
            it("EpubStoryReader correctly creates StoryBook from  - The Tale of Peter Rabbit") 
            {
                let epubStoryReader = EpubStoryReader()
                let epubURL = NSBundle(forClass: self.dynamicType).URLForResource(self.ePubsCollection[2], withExtension: "epub")!
                
                do 
                {
                    
                    let storyBook = try epubStoryReader.read(epubURL) 
                    
                    XCTAssertEqual(storyBook.info.coverImage, "@public@vhost@g@gutenberg@html@files@14838@14838-h@images@peter02.gif")//test pass: check if there is a cover
                        
                    XCTAssertEqual(storyBook.info.title,  "The Tale of Peter Rabbit")// test pass: check if the title is
                    
                    XCTAssertEqual(storyBook.info.authors,  "Beatrix Potter") //test pass: check the author name
                        
                    XCTAssertLessThan(storyBook.pages.count, 30) // test pass: check that the number of pages is less than
                    XCTAssertEqual(storyBook.pages.count, 27) // test pass: check if the number of pages is less equal to
      
                    XCTAssertEqual(storyBook.pages[20].pageNumber, 20) // test pass: check if the number of pages is less equal to
                    XCTAssertEqual(storyBook.pages[4].pageNumber, 4) // test pass: pages number
                    
                    XCTAssertEqual(storyBook.info.language, "En") // test fail: check language, it should be En
                    
                    XCTAssertEqual(storyBook.pages[0].paragraph, "Once upon a time there were four little Rabbits, and their names were— Flopsy, Mopsy, Cotton-tail,") //test pass:
                  
                    expect(storyBook.pages[26].paragraph) == "But Flopsy, Mopsy, and Cotton-tail had bread and milk and blackberries for supper. THE END"// test pass:
                       
                    expect(storyBook.pages[8].paragraph) == "And then, feeling rather sick, he went to look for some parsley." // test pass: pages amount
                    
                    expect(storyBook.pages[15].image) == "@public@vhost@g@gutenberg@html@files@14838@14838-h@images@peter36.jpg" // test fail: pages amount
                    
                    
                }catch let err {
                    XCTAssert(false, "\(err)")
                    
                    print(err)
                }
                
            }
        
            fit("EpubStoryReader correctly creates StoryBook from 'The Tailor of Gloucester'") 
            {
                
                let epubStoryReader = EpubStoryReader()
                let epubURL = NSBundle(forClass: self.dynamicType).URLForResource(self.ePubsCollection[1], withExtension: "epub")!
                
                do {
                    
                    let storyBook = try epubStoryReader.read(epubURL) 
                    
                    XCTAssertEqual(storyBook.info.coverImage, "@public@vhost@g@gutenberg@html@files@14868@14868-h@images@cover_final.jpg")//test fail: check if there is a cover
                    
                    XCTAssertEqual(storyBook.info.title,  "The Tailor of Gloucester")// test pass: check if the title is
                    
                    XCTAssertEqual(storyBook.info.authors, "Beatrix Potter") //test pass: check the author name
                    
                    XCTAssertLessThan(storyBook.pages.count, 40) //test: fail
                    XCTAssertEqual(storyBook.pages[3].pageNumber, 3) // test pass: pages number
                    
                    expect(storyBook.pages[0].paragraph) == "" // test pass: pages amount
                    expect(storyBook.pages[0].image) == "@public@vhost@g@gutenberg@html@files@14868@14868-h@images@cover_final.jpg"
                    expect(storyBook.info.publisher).to(equal(""))
                    
                    expect(storyBook.info.language).to(equal("En"))
                    
                    expect(storyBook.pages[6].paragraph) == "But the tailor came out of his shop, and shuffled home through the snow. He lived quite near by in College Court, next the doorway to College Green; and although it was not a big house, the tailor was so poor he only rented the kitchen. He lived alone with his cat; it was called Simpkin."
                    
                    
                }catch let err 
                {
                    XCTAssert(false, "\(err)")
                    
                    print(err)
                }
                
            }
            
            
            it("EpubStoryReader correctly creates StoryBook from 'The Tale of Johnny Town-Mouse'") 
            {
                
                let epubStoryReader = EpubStoryReader()
                let epubURL = NSBundle(forClass: self.dynamicType).URLForResource(self.ePubsCollection[2], withExtension: "epub")!
                                
                do {
                    
                    let storyBook = try epubStoryReader.read(epubURL) 
                    
                    XCTAssertEqual(storyBook.info.coverImage, "@public@vhost@g@gutenberg@html@files@14838@14838-h@images@peter02.gif")//test pass: check if there is a cover
                        
                    XCTAssertEqual(storyBook.info.title,  "The Tale of Johnny Town-Mouse")// test pass: check if the title is
                    
                    XCTAssertEqual(storyBook.info.authors,  "Beatrix Potter") //test pass: check the author name
                    XCTAssertEqual(storyBook.pages[4].pageNumber, 4) // test pass: pages number
                    
                    XCTAssertEqual(storyBook.info.language, "En") // test fail: check language, it should be En
                    expect(storyBook.info.publisher).to(equal(""))
                    
                    XCTAssertLessThan(storyBook.pages.count, 30) // test pass: 
                    XCTAssertEqual(storyBook.pages.first!.pageNumber, 4) // test fail: pages number
                    expect(storyBook.pages.count) == 25 // test pass: pages amount
                    
                    
                }catch let err 
                {
                    XCTAssert(false, "\(err)")
                    print(err)
                }
                
            }

            
            it("finds primary html resource") {

            }
            
            
        }
        
        
            
    }
}


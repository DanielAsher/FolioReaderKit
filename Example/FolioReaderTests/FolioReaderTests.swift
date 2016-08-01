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
        "The Tale of Johnny Town-Mouse",
        "The Story of Miss Moppet",
        "The Tale of Mrs. Tiggy-Winkle",
        "The Tale of Mrs. Tittlemouse",
        "The Tale of Ginger and Pickles",
        "The Tale of the Pie and the Patty Pan"
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
        
            it("EpubStoryReader correctly creates StoryBook from 'The Tailor of Gloucester'") 
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
                    let prefixOfLastSentence = String(storyBook.pages.last!.paragraph.characters.prefix(12))
//                    let expectedPrefixOfLastSentence = String("The stitches of those button-holes" .characters.prefix(12))
                    let result = 
                        storyBook.pages
                        .enumerate()
                        .filter { $0.element.paragraph.containsString("The stitches of those button-holes") }.first! 
                    print(result, storyBook.pages.count)
                    expect(prefixOfLastSentence) == String("The stitches of those button-holes".characters.prefix(12))
                    
                    
                }catch let err {
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
                    XCTAssertEqual(storyBook.pages.first!.pageNumber, 1) // test fail: pages number
                    expect(storyBook.pages.count) == 25 // test pass: pages amount
                    
                    expect(storyBook.pages.last?.paragraph) == "One place suits one person, another place suits another person. For my part I prefer to live in the country, like Timmy Willie." // last page
                    
                    expect(storyBook.pages.first?.paragraph) == "Johnny Town-mouse was born in a cupboard. Timmy Willie was born in a garden. Timmy Willie was a little country mouse who went to town by mistake in a hamper. The gardener sent vegetables to town once a week by carrier; he packed them in a big hamper."
                    
                    expect(storyBook.pages[19].paragraph) == "So Timmy Willie said good-bye to his new friends, and hid in the hamper with a crumb of cake and a withered cabbage leaf; and after much jolting, he was set down safely in his own garden."// test fail //16
                    
                    expect(storyBook.pages[18].paragraph) == "The winter passed; the sun came out again; Timmy Willie sat by his burrow warming his little fur coat and sniffing the smell of violets and spring grass. He had nearly forgotten his visit to town. When up the sandy path all spick and span with a brown leather bag came Johnny Town-mouse!" //test pass
                    
                    expect(storyBook.pages[12].image) == "@public@vhost@g@gutenberg@html@files@15284@15284-h@images@town14.jpg" // test pass
                    
                }catch let err 
                {
                    XCTAssert(false, "\(err)")
                    print(err)
                }
                
            }

            it("EpubStoryReader correctly creates StoryBook from 'The Story of Miss Moppet'") 
            {
                
                let epubStoryReader = EpubStoryReader()
                let epubURL = NSBundle(forClass: self.dynamicType).URLForResource(self.ePubsCollection[3], withExtension: "epub")!
                
                do {
                    
                    let storyBook = try epubStoryReader.read(epubURL) 
                    XCTAssertEqual(storyBook.info.coverImage, "@public@vhost@g@gutenberg@html@files@14848@14848-h@images@cover.jpg")//test pass: check if there is a cover
                    
                    XCTAssertEqual(storyBook.info.title,  "The Story of Miss Moppet")// test pass: check if the title is
                    
                    XCTAssertEqual(storyBook.info.authors,  "Beatrix Potter") //test pass: check the author name
                    XCTAssertEqual(storyBook.pages[4].pageNumber, 5) // test pass: pages number
                    
                    XCTAssertEqual(storyBook.info.language, "En") // test fail: check language, it should be En
                    expect(storyBook.info.publisher).to(equal(""))
                    
                    XCTAssertLessThan(storyBook.pages.count, 20) // test pass: 
                    XCTAssertEqual(storyBook.pages.first!.pageNumber, 1) // test pass: pages number
                    
                    
                    expect(storyBook.pages[0].paragraph.containsString("This is a Pussy called Miss Moppet")) == true
                    
                    expect(storyBook.pages[1].paragraph.containsString("This is the Mouse peeping out behind")) == true
                    
                    expect(storyBook.pages[2].paragraph.containsString("she misses the Mouse")) == true
                    expect(storyBook.pages[3].paragraph.containsString("is a very hard cupboard!")) == true
                    expect(storyBook.pages[4].paragraph.containsString("The Mouse watches Miss Moppet from")) == true
                    expect(storyBook.pages[5].paragraph.containsString("Miss Moppet ties up her head in a duster")) == true
                    expect(storyBook.pages[6].paragraph.containsString("The Mouse thinks she is looking very ill")) == true
                    expect(storyBook.pages[7].paragraph.containsString("The Mouse comes a little nearer")) == true
                    expect(storyBook.pages[8].paragraph.containsString("Miss Moppet holds her poor head in her paws, and looks at him through a hole in the duster.")) == true
                    expect(storyBook.pages[9].paragraph.containsString("Miss Moppet jumps upon the Mouse!")) == true
                    expect(storyBook.pages[10].paragraph.containsString("Miss Moppet—Miss Moppet thinks she will")) == true
                    expect(storyBook.pages[11].paragraph.containsString("and tosses it about like a ball")) == true
                    expect(storyBook.pages[12].paragraph.containsString(" and when she untied it—there was no Mouse!")) == true
                    expect(storyBook.pages[13].paragraph.containsString("a jig on the top of the cupboard!")) == true
                    
                }catch let err 
                {
                    XCTAssert(false, "\(err)")
                    print(err)
                }
                
            }
            
            
            it("EpubStoryReader correctly creates StoryBook from 'The Tale of Mrs. Tiggy-Winkle'") 
            {
                
                let epubStoryReader = EpubStoryReader()
                let epubURL = NSBundle(forClass: self.dynamicType).URLForResource(self.ePubsCollection[4], withExtension: "epub")!
                
                do {
                    
                    let storyBook = try epubStoryReader.read(epubURL) 
                    
                }catch let err 
                {
                    XCTAssert(false, "\(err)")
                    print(err)
                }
                
            }
            
            it("EpubStoryReader correctly creates StoryBook from 'The Tale of Mrs. Tittlemouse'") 
            {
                
                let epubStoryReader = EpubStoryReader()
                let epubURL = NSBundle(forClass: self.dynamicType).URLForResource(self.ePubsCollection[5], withExtension: "epub")!
                
                do {
                    
                    let storyBook = try epubStoryReader.read(epubURL) 
                    
                }catch let err 
                {
                    XCTAssert(false, "\(err)")
                    print(err)
                }
                
            }
            
            
            fit("EpubStoryReader correctly creates StoryBook from 'The Tale of Ginger and Pickles'") 
            {
                
                let epubStoryReader = EpubStoryReader()
                let epubURL = NSBundle(forClass: self.dynamicType).URLForResource(self.ePubsCollection[6], withExtension: "epub")!
                
                do {
                    
                    let storyBook = try epubStoryReader.read(epubURL) 
                    
                }catch let err 
                {
                    XCTAssert(false, "\(err)")
                    print(err)
                }
                
            }
            
            
                    
            it("finds primary html resource") {

            }
            
            
        }
        
        
        
        
//        func testMixedContentClassifier() {
//            let mixedContentXml = "<html><body><p>mixed content <i>iteration</i> support</p></body></html>"
//            
//            let mixedContentXml2 = 
//                "<root xmlns:h=\"http://www.w3.org/TR/html4/\"" +
//                    "  xmlns:f=\"http://www.w3schools.com/furniture\">" +
//                    "  <h:table>" +
//                    "    <h:tr>" +
//                    "      <h:td>Apples</h:td>" +
//                    "      <h:td>Bananas</h:td>" +
//                    "    </h:tr>" +
//                    "  </h:table>" +
//                    "  <f:table>" +
//                    "     My name is George," +
//                    "    <f:text>The African Coffee Table</f:text>" +
//                    "     I don't want to sit on the table," +
//                    "  </f:table>" +
//            "</root>"
//            
//            let mixedContentXml3 = "<p><i>I</i> have never felt sleepy after eating lettuces; but then <i>I</i> am not a rabbit.</p>"
//            
//            let xml = SWXMLHash.parse(mixedContentXml3)
//            let elementTypes = xml.element!.classifier( "" )
//            
//            let countChildren = xml["html"]["body"].all.count
//            //let countChildren = xml["root"].all.count
//            // print(elementTypes, countChildren)
//            
//            
//            //let res =  xml["root"]["h:table"]["h:tr"]["h:td"][0].element!.text!
//            //let res1 =  xml["root"]["f:table"].flatMap { $0 }
//            //let res2 =  xml["root"]["f:table"].flatMap { $0.element!.text! }
//            //print(res1)
//            
//        }
//    
        
        
            
    }
}


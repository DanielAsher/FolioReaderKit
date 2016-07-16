//
//  EpubStoryReader.swift
//  Example
//
//  Created by GEORGE QUENTIN on 12/07/2016.
//  Copyright © 2016 FolioReader. All rights reserved.
//

import Foundation
import FolioReaderKit
import AEXML

class EpubStoryReader : EpubStoryReading {
  
        
    func xmlDocuments(book: FRBook) -> [AEXMLDocument]
    {
        let xmlDocs =  book.spine.spineReferences.flatMap { spine -> AEXMLDocument? in
                              
            let opfData = try? NSData(contentsOfFile: spine.resource.fullHref, options: .DataReadingMappedAlways)
            let xmlDoc = try? AEXMLDocument(xmlData: opfData!)
            
            return xmlDoc
        }
        return xmlDocs
    }   
    
    private func findStoryStartingElement(root: AEXMLElement, element: String) -> AEXMLElement? {
        
        if let tableElements = root[element].all where tableElements.count == 1 {
            
            print("found one table \n")
            return root[element]
        }
        else {
            print("Warning: default root element returned in findStoryStartingElement \n")
            return nil
        }
    }
    
    func read(path: NSURL) throws -> StoryBook {
        
        let parser = FREpubParser()
        
        parser.readEpub(epubPath: path.path!)
        let book = parser.book
        
        //let basePath = book.spine.spineReferences.first?.resource.basePath() ?? ""
        let coverImage = book.coverImage?.href ?? ""
        let authorNames = book.metadata.creators.flatMap { $0.name }
        let author = authorNames.joinWithSeparator(", ")
        let language = book.metadata.language.capitalizedString
        let publisher = book.metadata.publishers.joinWithSeparator(" ")
        let date = book.metadata.dates.first?.date ?? ""
        let title = book.metadata.titles.first ?? ""
        
        print("\n cover \(coverImage)")
        print("language ===== \(language)")
        print("title ===== \(title)")
        print("author ===== \(author)")
        print("publisher ===== \(publisher) \n")
        
        let storyBookInfo = StoryBookInfo(coverImage: coverImage, title: title, authors: author, language: language, date: date, publisher: publisher)
        
        let xmlDocs = xmlDocuments(book)
        
        let storyPages = 
            xmlDocs
            .filter { $0.root["body"].children.count > 1 } 
            .flatMap { xmlDoc -> [StoryPage] in
        
            let body = xmlDoc.root["body"]
            
            //guard let storyStartElement = 
            //    self.findStoryStartingElement(body, element: "div") else { return [] }//table
           
                
            var mainPages =  
                //storyStartElement.classify("tr")
                //body.classify("table")
                body.classify("p") 
                //storyStartElement.classify("div") 
                    .split { $0.isHrPageMarker() }
                    
                    //.dropFirst(2)
                    
                    .flatMap { $0 }
                    
                    .last!
                    
                    
                    .split { $0.isPagebreak() }
                    .map { $0.flatMap { $0 } 
            }
            
            //mainPages.removeFirst()
                
            mainPages[0].removeFirst()
            let changed = mainPages.flatMap{ $0 }.splitInChunks(2)
            mainPages = changed
           
            mainPages.forEach{ print("\($0) \n") }
            //mainPages.flatMap{ $0 }.forEach{ print("\($0) \n") }
            
            
            let mainStoryPages = mainPages.enumerate().map { (pageNumber, arrayOfElementTypes) -> StoryPage in 
                
                let firstImgage = arrayOfElementTypes.flatMap { $0.getImage() }.first ?? ""
                let texts =  arrayOfElementTypes.flatMap { $0.getText() }.joinWithSeparator(" ")

                print("\n page number ===== \(pageNumber)")
                print("\n Image ===== \(firstImgage) \n ")
                print(" paragraph ===== \(texts) \n")
                //print("arrayOfElementTypes.count", arrayOfElementTypes.count)
                
                let storyPage = StoryPage(image: firstImgage, paragraph: texts, pageNumber: pageNumber)
                                
                return storyPage
            }

            return mainStoryPages
            
        }
        
        let storyBook = StoryBook(info: storyBookInfo, pages: storyPages)
        
        return storyBook
    }
    
    
    
}


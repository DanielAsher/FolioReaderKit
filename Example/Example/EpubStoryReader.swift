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
    
    private func findStoryStartingElement(root: AEXMLElement) -> AEXMLElement? {
        
        if let tableElements = root["table"].all where tableElements.count == 1 {
            
            print("found one table \n")
            return root["table"]
        } else {
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
        
            //let head = xmlDoc.root["head"]
            let body = xmlDoc.root["body"]
            guard let storyStartElement = self.findStoryStartingElement(body) 
                else { return [] }
            
            let allResults = storyStartElement.classify("tr") //tr//p//table
            //allResults.forEach { print($0) }
            
//            let introPages =    
//                allResults
//                    .split { $0.addHrPageMarker() }
//                    .map { $0.flatMap { $0 } }
//                    .dropLast()
//            
//            let introPages =    
//                allResults
//                    .split { $0.addHrPageMarker() }
//                    .map { $0.flatMap { $0 } }
//                    .dropLast(2)
//            //introPages.forEach { print($0) }
//            //print("\n Intro pages: \(introPages.count) \n")
//            
//                
////            let mainPages =    
////                allResults
////                    .split { $0.addHrPageMarker() }
////                    .last
////                    .flatMap{ $0 }!
////                    .split { $0.addPagebreak() }
////                    .map { $0.flatMap { $0 } }
//            
            let mainPages =    
                allResults
                    .split { $0.addPagebreak() }
                    .map { $0.flatMap { $0 } }
            //mainPages.forEach { print($0) }
            //print("\n Main pages: \(mainPages.count) \n")
            
            
////            let introStoryPages = introPages.enumerate().map { (pageNumber, arrayOfElementTypes) -> StoryPage in 
////                
////                let firstImgage = arrayOfElementTypes.flatMap { $0.getImage() }.first ?? ""
////                let texts =  arrayOfElementTypes.flatMap { $0.getText() }.joinWithSeparator(" ")
////                
////                print("\n TopImages ===== \(firstImgage) \n ")
////                print(" Top Paragraph ===== \(texts) \n")
////                
////                let storyPage = StoryPage(image: firstImgage, paragraph: texts, pageNumber: pageNumber)
////                
////                
////                return storyPage
////            }
////            
//            
//                        
                let mainStoryPages = mainPages.enumerate().map { (pageNumber, arrayOfElementTypes) -> StoryPage in 
                
                let firstImgage = arrayOfElementTypes.flatMap { $0.getImage() }.first ?? ""
                let texts =  arrayOfElementTypes.flatMap { $0.getText() }.joinWithSeparator(" ")

                print("\n page number ===== \(pageNumber)")
                print("\n Image ===== \(firstImgage) \n ")
                print(" paragraph ===== \(texts) \n")
                
                let storyPage = StoryPage(image: firstImgage, paragraph: texts, pageNumber: pageNumber)
                                
                return storyPage
            }

            return mainStoryPages
            
        }
        
        let storyBook = StoryBook(info: storyBookInfo, pages: storyPages)
        
        return storyBook
    }
    
    
    
}


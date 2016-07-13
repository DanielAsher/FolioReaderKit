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
    
    func read(path: NSURL) throws -> StoryBook {
        
        let parser = FREpubParser()
        
        parser.readEpub(epubPath: path.path!)
        let book = parser.book
        let xmlDocs = xmlDocuments(book)
        
        let basePath = book.spine.spineReferences.first?.resource.basePath() ?? ""
        let coverFullref = book.coverImage?.fullHref ?? ""
        let cover = "\(basePath)/\(coverFullref)"
        
        
        let authorNames = book.metadata.creators.flatMap { $0.name }
        let author = authorNames.joinWithSeparator(", ")
        let language = book.metadata.language.capitalizedString
        let publisher = book.metadata.publishers.joinWithSeparator(" ")
        let date = book.metadata.dates.first?.date ?? ""
        let title = book.metadata.titles.first ?? ""
        
        print("\n cover ===== \(cover)")
        print("language ===== \(language)")
        print("title ===== \(title)")
        print("author ===== \(author) \n")
        
        let storyBookInfo = StoryBookInfo(cover: cover, title: title, authors: author, language: language, date: date, publisher: publisher)
        
        let storyPages = xmlDocs.flatMap { xmlDoc -> [StoryPage] in

            //let head = xmlDoc.root["head"]
            let body = xmlDoc.root["body"]
           
            let allResults = body.classify("tr") 
            allResults.forEach { print($0) }
            
            let introPages =    
                allResults
                    .split { $0.addHrPageMarker() }
                    .map { $0.flatMap { $0 } }
                    .dropLast()
            
            //introPages.forEach { print($0) }
            //print("\n Intro pages: \(introPages.count) \n")
            
            let mainPages =    
                allResults
                    .split { $0.addHrPageMarker() }
                    .last.flatMap{ $0 }!
                    .split { $0.addPagebreak() }
                    .map { $0.flatMap { $0 } }
            //mainPages.forEach { print($0) }
            //print("\n Main pages: \(mainPages.count) \n")
            
            
            
            var pageNum1 = 0
            let introStoryPages = introPages.map { arrayOfElementTypes -> StoryPage in 
                
                let firstImgage = arrayOfElementTypes.flatMap { $0.getImage() }.first ?? ""
                let texts =  arrayOfElementTypes.flatMap { $0.getText() }.joinWithSeparator(" ")
                
                print("\n TopImages ===== \(firstImgage) \n ")
                print(" Top Paragraph ===== \(texts) \n")
                
                let storyPage = StoryPage(image: firstImgage, paragraph: texts, pageNumber: pageNum1)
                
                pageNum1 += 1
                
                return storyPage
            }
            
            
            
            var pageNum2 = 0
            let mainStoryPages = mainPages.map { arrayOfElementTypes -> StoryPage in 
                
                let firstImgage = arrayOfElementTypes.flatMap { $0.getImage() }.first ?? ""
                let texts =  arrayOfElementTypes.flatMap { $0.getText() }.joinWithSeparator(" ")
//                let pageNum =  mainPages.reduce(0) { acc, x in return acc + 1 }
               
                print("\n page number ===== \(pageNum2)")
                print("\n Image ===== \(firstImgage) \n ")
                print(" paragraph ===== \(texts) \n")
                
                let storyPage = StoryPage(image: firstImgage, paragraph: texts, pageNumber: pageNum2)
                pageNum2 += 1
                
                return storyPage
            }

            return mainStoryPages
            
        }
        
        let storyBook = StoryBook(info: storyBookInfo, pages: storyPages)
        
        return storyBook
    }
    
    
    
}


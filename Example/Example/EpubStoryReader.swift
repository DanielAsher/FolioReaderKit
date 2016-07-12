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

        let cover = book.coverImage?.fullHref ?? ""
        let authorNames = book.metadata.creators.flatMap { $0.name }
        let author = authorNames.joinWithSeparator(", ")
        let language = book.metadata.language.capitalizedString
        let publisher = book.metadata.publishers.joinWithSeparator(" ")
        let date = book.metadata.dates.first?.date ?? ""
        let title = book.metadata.titles.first ?? ""
        
        print("cover ===== \(cover)")
        print("language ===== \(language)")
        print("title ===== \(title)")
        print("author ===== \(author)")
        
        let storyBookInfo = StoryBookInfo(cover: cover, title: title, authors: author, language: language, date: date, publisher: publisher)
        
        let storyPages = xmlDocs.flatMap { xmlDoc -> [StoryPage] in

            //let head = xmlDoc.root["head"]
            let body = xmlDoc.root["body"]
           
            let allResults = body.classify()
            
            let pagesFound = allResults.split { 
                switch $0 { 
                case ElementType.pagebreak: return true
                default: return false } 
            }.map { $0.flatMap { $0 } }
            
            
            let pages = pagesFound.map { arrayOfElementTypes -> StoryPage in 
                
                let firstImg = arrayOfElementTypes.flatMap { $0.getImage() }.first ?? ""
                let allText =  arrayOfElementTypes.flatMap { $0.getText() }.joinWithSeparator(" ")
               
                print("firstImgage ===== \(firstImg)")
                print("allText ===== \(allText)")
                
                let storyPage = StoryPage(image: firstImg, paragraph: allText)
                
                return storyPage
                
            }

            return pages
            
        }
        
        let storyBook = StoryBook(info: storyBookInfo, pages: storyPages)
        
        return storyBook
    }
    
    
    
}


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

        let subject: FREpubParser = FREpubParser()
        
        let book = subject.book
        let xmlDocs = xmlDocuments(book)
        var storyBookInfo = StoryBookInfo()
        var storyPage : [StoryPage] = []
        var storyBook = StoryBook()

        xmlDocs.forEach { xmlDoc in 

            let cover = book.coverImage?.fullHref ?? ""
            let authorNames = book.metadata.creators.flatMap { $0.name }
            let author = authorNames.joinWithSeparator(", ")
            let language = book.metadata.language.capitalizedString
            let publisher = book.metadata.publishers.joinWithSeparator(" ")
            
            guard 
                let title = book.metadata.titles.first,
                let date = book.metadata.dates.first?.date
                
                else { return }
            
            
            //let head = xmlDoc.root["head"]
            //let body = xmlDoc.root["body"]
            
            //print(cover, title, author)
            storyBookInfo = StoryBookInfo(cover: cover, title: title, authors: author, language: language, date: date, publisher: publisher)
            
     
//        let imageDescription = images[pageNumber].lazy.flatMap { $0 }
//        let pageDescription = paragraphs[pageNumber].lazy.flatMap { $0 } 
//            
//        let page = pageDescription.reduce("") { acc, x in
//                let res = acc + " " + x.description
//                return res
//        }
//        guard let image = imageDescription.first?.description else { return }
          //  storyPage = StoryPage(image: resource.basePath() + "/" + image, paragraph: page)
           
            storyBook = StoryBook(info: storyBookInfo, pages: storyPage)
        }
        
        throw EpubStoryReadingError.FileNotFound
        return storyBook
    }
}


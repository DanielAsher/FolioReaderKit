//
//  CecilyParsleysNurseryRhymes.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash


class CecilyParsleysNurseryRhymes : EpubStoryBookReading {
 
    var startMarker : String = "" 
    var endMarker : String = ""
    
    init(startMarker: String, endMarker: String) {
        self.startMarker = startMarker
        self.endMarker = endMarker
    }
    
    func getCoverImage(book: FRBook, parser: [XMLIndexer]) -> String {
        let coverImage = parser[0]["html"]["body"].children[3].element!.classifier( "" ).flatMap { $0.getImage() }.joinWithSeparator("")
        
        return coverImage
    }
    
    
    func getStoryPages(parser: [XMLIndexer]) -> [StoryPage]
    {
        let classifier = Classifier()
        let storyPagesFilter = StoryPagesFilters()
        
        let storyPages = parser
            .filter { $0["html"]["body"].children.count > 1 } 
            .flatMap { xmlDoc -> [StoryPage] in
                
                let body = xmlDoc["html"]["body"]
                
                let xmlList = classifier.classifyBodyWithStartAndEndMarkerWithTablePerPage(body, startMarker: self.startMarker, endMarker: self.endMarker,startPos: 0,endPos: -1, pageBreakType: "div")
                
                let pageBreakInts = [0,4,8,14,18,21,24,29,36,42,50,56,62,68]
                
                let mainStoryPages = storyPagesFilter.filteringMainPagesWithPageBreakArray(xmlList, pageBreaks: pageBreakInts)
                
                
                return mainStoryPages
        }
        
        return storyPages
    }
    
    
    
}
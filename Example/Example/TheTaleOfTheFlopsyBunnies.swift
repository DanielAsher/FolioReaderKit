//
//  TheTaleOfTheFlopsyBunnies.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash

class TheTaleOfTheFlopsyBunnies : EpubStoryBookReading {
    
    var startMarker : String = "" 
    var endMarker : String = ""
    
    init(startMarker: String, endMarker: String) {
        self.startMarker = startMarker
        self.endMarker = endMarker
    }
    
    
    func getCoverImage(book: FRBook, parser: [XMLIndexer]) -> String {
        let coverImage = parser[0]["html"]["body"].children[1]["a"].element!.classifier( "" ).flatMap { $0.getImage() }.joinWithSeparator("")
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
                
                let xmlList = classifier.classifyBodyWithStartAndEndMarkerWithTablePerPage(body, startMarker: self.startMarker, endMarker: self.endMarker,startPos: -2,endPos: 0, pageBreakType: "div")
                
                let mainStoryPages = storyPagesFilter.filteringMainPagesWithPageBreak(xmlList)

                return mainStoryPages      
        }
        
        
        return storyPages
    }
    
    
}
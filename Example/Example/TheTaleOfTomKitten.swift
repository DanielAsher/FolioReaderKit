//
//  TheTaleOfTomKitten.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash

class TheTaleOfTomKitten : EpubStoryBookReading {
    
    var startMarker : String = "" 
    var endMarker : String = ""
    
    init(startMarker: String, endMarker: String) {
        self.startMarker = startMarker
        self.endMarker = endMarker
    }
    
    
    
    func getCoverImage(book: FRBook, parser: [XMLIndexer]) -> String {
        let coverImage = parser[0]["html"]["body"].children[2].element!.classifier( "" ).flatMap { $0.getImage() }.joinWithSeparator("")//.....Benjamin Bunny
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
                
                let xmlList = classifier.classifyBodyWithStartAndEndMarkerWithTablePerPage(body, startMarker: self.startMarker, endMarker: self.endMarker,startPos: 0,endPos: 0, pageBreakType: "div")
               
                let pageBreakInts = [0,6,9,12,16,19,23,26,30,34,37,41,45,48,51,56,59,65,69,72,76,79,85,88,93]//.....Tom Kitten
                
                let mainStoryPages = storyPagesFilter.filteringMainPagesWithPageBreakArray(xmlList, pageBreaks: pageBreakInts)

                return mainStoryPages      
        }
        
        
        return storyPages
    }
    
    
}
//
//  TheTaleOfGingerAndPickles.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash


class TheTaleOfGingerAndPickles : EpubStoryBookReading {

    var startMarker : String = "" 
    var endMarker : String = ""
    
    init(startMarker: String, endMarker: String) {
        self.startMarker = startMarker
        self.endMarker = endMarker
    }
    
    
    func getCoverImage(book: FRBook, parser: [XMLIndexer]) -> String {
        let coverImage = parser[1]["html"]["body"].children[11].element!.classifier( "" ).flatMap { $0.getImage() }.joinWithSeparator("")//.....Ginger and Pickles
        
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
                
                let xmlList = classifier.classifyBodyWithStartAndEndMarkerWithTablePerPage(body, startMarker: self.startMarker, endMarker: self.endMarker,startPos: -1,endPos: 0, pageBreakType: "p")
               
                let pageBreakInts = 
                    [0,7,13,19,24,30,34,38,43,
                        50,55,63,69,73,78,83,88,92,
                        95,98,101,107,111,115,118,
                        121,126,130] //.....Ginger and Pickles
                let mainStoryPages = storyPagesFilter.filteringMainPagesWithPageBreakArray(xmlList, pageBreaks: pageBreakInts)
                
             return mainStoryPages      
        }
        
        
        return storyPages
    }
    
    
    
}
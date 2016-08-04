//
//  TheTaleOfMrsTittlemouse.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash

class TheTaleOfMrsTittlemouse : EpubStoryBookReading {
    
    var startMarker : String = "" 
    var endMarker : String = ""
    
    init(startMarker: String, endMarker: String) {
        self.startMarker = startMarker
        self.endMarker = endMarker
    }
    
    
    func getStoryPages(parser: [XMLIndexer]) -> [StoryPage]
    {
        
        let classifier = Classifier()
        let storyPagesFilter = StoryPagesFilters()
        
        let storyPages = parser
            .filter { $0["html"]["body"].children.count > 1 }
            .flatMap { xmlDoc -> [StoryPage] in
                
                let body = xmlDoc["html"]["body"]
                
                let xmlList = classifier.classifyBodyWithStartAndEndMarkerWithTablePerPage(body, startMarker: self.startMarker, endMarker: self.endMarker,startPos: 0,endPos: 0, pageBreakType: "table")
                
                let mainStoryPages = storyPagesFilter.filteringMainPagesWithPageBreak(xmlList)
                return mainStoryPages      
        }
        
        
        return storyPages
    }
    
    
    
}
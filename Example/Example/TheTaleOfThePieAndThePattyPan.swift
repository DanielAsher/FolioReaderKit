//
//  TheTaleOfThePieAndThePattyPan.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash

class TheTaleOfThePieAndThePattyPan : EpubStoryBookReading {
    
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
                
                let xmlList = classifier.classifyBodyWithStartAndEndMarkerWithTablePerPage(body, startMarker: self.startMarker, endMarker: self.endMarker,startPos: -1,endPos: 0, pageBreakType: "p")

                let pageBreakInts = 
                    [0,9,20,32,45,54,59,67,72,83,89,97,
                    111,117,126,135,140,146,153,157,165,180,
                    197,207,218,229,235,253] //.....Pie and the Patty Pan
                
                let mainStoryPages = storyPagesFilter.filteringMainPagesWithPageBreakArray(xmlList, pageBreaks: pageBreakInts)
                
                return mainStoryPages      
        }
        
        
        return storyPages
    }

    
    
}
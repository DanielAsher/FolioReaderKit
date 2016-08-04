//
//  TheTaleOfPeterRabbit.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash
// Change name to describe the pattern.
class TheTaleOfPeterRabbit : EpubStoryBookReading {

    var startMarker : String = "" 
    var endMarker : String = ""
    var coverImgPath : String?
    let startPosOffset: Int
    let endPositionOffset: Int
    
    init(startMarker: String, 
         endMarker: String, 
         startPosOffset: Int = 0, 
         endPositionOffset: Int = 0,
         coverImgPath: String? = nil
         ) {
        self.startMarker = startMarker
        self.endMarker = endMarker
        self.startPosOffset = startPosOffset
        self.endPositionOffset = endPositionOffset
        self.coverImgPath = coverImgPath
    }
   
    
    func getStoryPages(parser: [XMLIndexer]) -> [StoryPage]
    {
        let classifier = Classifier()
        let storyPagesFilter = StoryPagesFilters()
        
        let storyPages = parser
            .filter { $0["html"]["body"].children.count > 1 }
            .flatMap { xmlDoc -> [StoryPage] in
                
                let body = xmlDoc["html"]["body"]
                
                //body.children.flatMap { print($0.element?.description) }
                
                let xmlList = classifier.classifyBodyWithStartAndEndMarkerWithTablePerPage(body, startMarker: self.startMarker, endMarker: self.endMarker,startPos: self.startPosOffset,endPos: self.endPositionOffset, pageBreakType: "table")
                
                let mainStoryPages = storyPagesFilter.filteringTheTaleOfPeterRabbitMainPages(xmlList)
                
                return mainStoryPages      
        }
        
        
        return storyPages
    }
    
    
}
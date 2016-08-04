//
//  TheTaleOfMrJeremyFisher.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash

class TheTaleOfMrJeremyFisher : EpubStoryBookReading{
    
    var startMarker : String = "" 
    var endMarker : String = ""
    
    init(startMarker: String, endMarker: String) {
        self.startMarker = startMarker
        self.endMarker = endMarker
    }
    
    
    
    func getCoverImage(book: FRBook, parser: [XMLIndexer]) -> String {
        
        let coverImage = parser[0]["html"]["body"].children[11].element!.classifier( "" ).flatMap { $0.getImage() }.joinWithSeparator("")//.....Benjamin Bunny
        
        
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
                
                let xmlList = classifier.classifyBodyWithStartAndEndMarkerWithTablePerPage(body, startMarker: self.startMarker, endMarker: self.endMarker,startPos: 2,endPos: -1, pageBreakType: "p")
               
                let pageBreakInts = [0,3,7, 11,14,17,20,24,
                    27,31,35,39,43,47,50,53,56,64,
                    68,71,74,77,80, 83, 86,89] //.....Mr. Jeremy Fisher 
                
                let mainStoryPages = storyPagesFilter.filteringMainPagesWithPageBreakArray(xmlList, pageBreaks: pageBreakInts)
                

                return mainStoryPages      
        }
        
        
        return storyPages
    }
    
    
}
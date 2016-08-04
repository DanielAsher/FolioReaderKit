//
//  TheTaleOfSamuelWhiskersOrTheRolyPolyPudding.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash

class TheTaleOfSamuelWhiskersOrTheRolyPolyPudding : EpubStoryBookReading {
    
    var startMarker : String = "" 
    var endMarker : String = ""
    
    init(startMarker: String, endMarker: String) {
        self.startMarker = startMarker
        self.endMarker = endMarker
    }
    
    
    
    func getCoverImage(book: FRBook, parser: [XMLIndexer]) -> String {
        let coverImage = parser[1]["html"]["body"].children[22]["a"].element!.classifier( "" ).flatMap { $0.getImage() }.joinWithSeparator("")//.....Roly-Poly Pudding
        
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
                    [0,5,11,15,20,23,26,33,36,
                        41,46,50,54,61,64,68,78,
                        
                        84,89,93,97,101,105,108,113,
                        116,119,122,125,134,
                        137,142,149,
                        153,157,161,165,170,177,
                        
                        181,185,193,200,205,209,212,
                        219,230,233,236,240,244,248,255] ////.....Roly-Poly Pudding
                
               
                let mainStoryPages = storyPagesFilter.filteringMainPagesWithPageBreakArray(xmlList, pageBreaks: pageBreakInts)
                
                return mainStoryPages      
        }
        
        
        return storyPages
    }
    
    
}
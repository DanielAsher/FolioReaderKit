//
//  TheTaleOfTimmyTiptoes.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash

class TheTaleOfTimmyTiptoes : EpubStoryBookReading {
    
    var startMarker : String = "" 
    var endMarker : String = ""
    
    init(startMarker: String, endMarker: String) {
        self.startMarker = startMarker
        self.endMarker = endMarker
    }
    
    func getCoverImage(book: FRBook, parser: [XMLIndexer]) -> String {
        let coverImage = parser[0]["html"]["body"].children[3]["a"].element!.classifier( "" ).flatMap { $0.getImage() }.joinWithSeparator("")//.....Timmy Tiptoes
        
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
               
                let mainStoryPages = storyPagesFilter.filteringMainPagesImageToTextStructure(xmlList)
                
                
                return mainStoryPages      
        }
        
        
        return storyPages
    }
    
    
    
}
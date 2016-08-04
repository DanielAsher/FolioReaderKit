//
//  TheTaleOfMrTod.swift
//  StorySmartiesServices
//
//  Created by GEORGE QUENTIN on 26/07/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SWXMLHash

class TheTaleOfMrTod : EpubStoryBookReading {
    
    let htmlIndex: Int
    var startMarker : String = "" 
    var endMarker : String = ""
    let startPositionOffset: Int
    let endPositionOffset: Int
    var coverImgPath : String?
    var pageBreakType : String 
    var pageBreakIndexes : [Int]
    
    init(htmlIndex: Int = 0,
         startMarker: String, 
         endMarker: String, 
         startPositionOffset: Int = 0, 
         endPositionOffset: Int = 0,
         pageBreakType: String = "",
         coverImagePath: String? = nil,
         pageBreakIndexes: [Int] = []
        
        
        ) {
        self.htmlIndex = htmlIndex
        self.startMarker = startMarker
        self.endMarker = endMarker
        self.startPositionOffset = startPositionOffset
        self.endPositionOffset = endPositionOffset
        self.coverImgPath = coverImagePath
        self.pageBreakType = pageBreakType
        self.pageBreakIndexes = pageBreakIndexes
    }
    
    
    func getCoverImage(book: FRBook, parser: [XMLIndexer]) -> String {
       
        let coverImage = parser[0]["html"]["body"].children[1]["a"].element!.classifier( "" ).flatMap { $0.getImage() }.joinWithSeparator("")//.....Mr Tod (picture with index 1 or 4)
        
        return coverImage
    }
    
    
    func getStoryPages(parser: [XMLIndexer]) -> [StoryPage]
    {
        let classifier = Classifier()
        let elementTypeArrays = ElementTypeArrays()
        let storyPagesFilter = StoryPagesFilters()
        
        print("number of html doc: ", parser.count)
       
        let storyPages = parser
            .filter { $0["html"]["body"].children.count > 1 }
            .enumerate()
            .flatMap { (ind,xmlDoc) -> [StoryPage] in
                
                let body = xmlDoc["html"]["body"]
                
                if ind == self.htmlIndex {
                    
                    let xmlList = classifier.classifyBodyWithStartAndEndMarkerWithTablePerPage(body, startMarker: self.startMarker, endMarker: self.endMarker,startPos: self.startPositionOffset,endPos: self.endPositionOffset, pageBreakType: self.pageBreakType)
                    
                    //xmlList.flatMap { print($0) }
                    
                    //let pageBreakInts = 
//                        [0,4,8,18, 24,28, 33,  40, 47,  53, 60,
//                            70,77, 80,84,90,96,101,110,115,123,131,
//                            137,141,148,152,157,163,170,175,183,
//                            187,191,203,208,214,217,223,230,233,
//                            245,252,258,261,265,275]//....Mr Tod
                    
                    //original
                    //                    [0,4,8,17,23,26,30,36,42,48,55,60,
                    //                    71,80,84,90,96,101,110,115,123,131,
                    //                    137,141,148,152,157,163,170,175,183,
                    //                    187,191,203,208,214,217,223,228,231,
                    //                    240,246,253,257,260,269,274,286]//....Mr Tod

                    
                    let mainStoryPages = storyPagesFilter.filteringMainPagesWithPageBreakArray(xmlList, pageBreaks: self.pageBreakIndexes)
                    
                    return mainStoryPages
                    
                }else {
                    
                    //let pageBreakInts = [3,6,12,16]//....Mr Tod
                    return []
                    
                }
                
                
                    
        }
        
        
        return storyPages
    }
    
    
}
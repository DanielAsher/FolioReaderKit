//
//  ElementType.swift
//  Example
//
//  Created by GEORGE QUENTIN on 11/07/2016.
//  Copyright © 2016 FolioReader. All rights reserved.
//

import Foundation
import AEXML

enum ElementType : CustomStringConvertible {
    case text(String)
    case image(String) // typealias Href
    case hrPageMarker
    case pagebreak
    
    var description: String {
        switch self {
        case let .text(str): return "text: \(str)"
        case let .image(href) : return "image: \(href)"
        case .hrPageMarker: return "hrPageMarker: "
        case .pagebreak: return "pagebreak: "
            
        }
    }
    
    func getText() -> String? {
        switch self {
        case .text(let href): return href
        default: return nil
        }
        
    }
    
    func getImage() -> String? {
        switch self {
        case .image(let txt): return txt
        default: return nil
        }        
    }
    
    func isPagebreak() -> Bool {
        switch self {
        case .pagebreak: return true
        default: return false
        }
    }
    
    func isHrPageMarker() -> Bool {
        switch self {
        case .hrPageMarker: return true
        default: return false
        }
    }
    
    
    
    
}

extension Array {
    
    func splitInChunks(chunkSize : Int) -> Array<Array<Element>> {
        return 0.stride(to: self.count, by: chunkSize)
            .map { Array(self[$0..<$0.advancedBy(chunkSize, limit: self.count)]) }
    }
}


extension AEXMLElement {
    
    func classify(type: String ) -> [ElementType] {
        
        //print("names:  ==  \(self.name) = childrens === \(self.children.count)")
        
        switch (self.children.count, self.name) {
            
            case (0, _):
                if let href = self.attributes["src"] where self.name == "img" {
                    return [.image(href)]
                } 
                else if self.name == "hr" {
                    return [.hrPageMarker]
                }
                else if let textContent = self.value {
                    return [.text(textContent)]
                } else {
                    return []//[.empty]
                }
            case (_, type): 
                return  [.pagebreak] + self.children.flatMap { $0.classify( type ) } 
                
            case _:
                return self.children.flatMap { $0.classify( type ) }
        }
        
        
    }

}
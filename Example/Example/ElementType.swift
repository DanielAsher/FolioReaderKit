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
    case firstPageMarker
    case pagebreak
    
    var description: String {
        switch self {
        case let .text(str): return "\(str)"
        case let .image(href) : return "\(href)"
        case .firstPageMarker: return "firstPage"
        case .pagebreak: return "pagebreak: "
            
        }
    }
}

extension AEXMLElement {
    func classify() -> [ElementType] {
        switch (self.children.count, self.name) {
        case (0, _):
            if let href = self.attributes["src"] where self.name == "img" {
                return [.image(href)]
            } else if self.name == "hr" {
                return [.pagebreak]
            }
            else if let textContent = self.value {
                return [.text(textContent)]
            } else {
                return []//[.empty]
            }
        case (_, "table"):
            return [.pagebreak] + self.children.flatMap { $0.classify() }
        case _:
            return self.children.flatMap { $0.classify() }
        }
    }

}
//
//  DOMParserTests.swift
//  Example
//
//  Created by GEORGE QUENTIN on 08/07/2016.
//  Copyright © 2016 FolioReader. All rights reserved.
//

@testable import FolioReaderKit

import Quick
import Nimble
import AEXML

class DOMParserTests : QuickSpec {
    
    override func spec() {
        context("the DOM parser") {
            it("retrieves all text in an element with both content and children") {
                let xmlString = "<p>The stitches of those button-holes were so small—<i>so</i> small—they looked as if they had been made by little mice!</p>"
                
                let outputReferenceText = "The stitches of those button-holes were so small—so small—they looked as if they had been made by little mice!"
                
                func parseElementWithContentAndChildren(document: AEXMLDocument) -> String {
                    let retVal = [document.root.stringValue] + document.root.children.map { $0.stringValue }
                    
                    return retVal.joinWithSeparator("")
                }
                
                let stringData = xmlString.dataUsingEncoding(NSUTF8StringEncoding)
                do {
                    let mockElement = try AEXMLDocument(xmlData: stringData!)
                    let outputText = parseElementWithContentAndChildren(mockElement)
                   print("\n\noutputText:", outputText, "\n\n\n") 
                    expect(outputText).to(equal(outputReferenceText))
                } catch {
                    XCTAssert(false)
                }
                
                
                
            }
        }
    }
    
}

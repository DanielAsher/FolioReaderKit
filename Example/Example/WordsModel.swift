//
//  MainScript.swift
//  AlienPhonicsSpriteKit
//
//  Created by GEORGE QUENTIN on 25/02/2016.
//  Copyright © 2016 GEORGE QUENTIN. All rights reserved.
//
import Foundation
import UIKit
import SpriteKit
@testable import FolioReaderKit


extension String {

   
    
}

extension SequenceType where Generator.Element == String {
    
    func myJoinWithSeperator(seperator: String) -> String {
        return self.reduce("") { acc, string in
            return acc + seperator + string
        }
    }
}
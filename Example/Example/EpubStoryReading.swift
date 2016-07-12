//
//  EpubStoryReading.swift
//  Example
//
//  Created by GEORGE QUENTIN on 12/07/2016.
//  Copyright © 2016 FolioReader. All rights reserved.
//

import Foundation
import FolioReaderKit

enum EpubStoryReadingError : ErrorType {
    case FileNotFound
}

protocol EpubStoryReading { 
    
    func read(path: NSURL) throws -> StoryBook
}

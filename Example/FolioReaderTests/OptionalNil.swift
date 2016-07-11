//
//  OptionalNil.swift
//  Example
//
//  Created by GEORGE QUENTIN on 11/07/2016.
//  Copyright © 2016 FolioReader. All rights reserved.
//

import Foundation
@testable import FolioReaderKit

public func nilString(str: String?) -> String?
{
    if str == nil {
        return String()
        
    }else{
        return str
    }
    
}

func nilFRResourse(res: FRResource?) -> String?
{
    
    if res == nil {
        return String()
        
    }else{
        return res?.fullHref
    }
    
}
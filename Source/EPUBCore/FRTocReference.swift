//
//  FRTocReference.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 06/05/15.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import UIKit

public class FRTocReference: NSObject {
    public var resource: FRResource?
    public var title: String!
    public var fragmentID: String?
    public var children: [FRTocReference]!
    
    convenience init(title: String, resource: FRResource?, fragmentID: String = "") {
        self.init(title: title, resource: resource, fragmentID: fragmentID, children: [FRTocReference]())
    }
    
    init(title:String, resource: FRResource?, fragmentID: String, children: [FRTocReference]) {
        self.resource = resource
        self.title = title
        self.fragmentID = fragmentID
        self.children = children
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        let obj = object as! FRTocReference
        return obj.title == self.title && obj.fragmentID == self.fragmentID
    }
}

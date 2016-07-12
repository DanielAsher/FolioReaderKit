//
//  FRResource.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 29/04/15.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import UIKit

public class FRResource: NSObject {
    public var id: String!
    public var title: String!
    public var href: String!
    public var fullHref: String!
    public var mediaType: MediaType!
    public var mediaOverlay: String!
    public var inputEncoding: String!

    public func basePath() -> String! {
        if href == nil || href.isEmpty { return nil }
        var paths = fullHref.componentsSeparatedByString("/")
        paths.removeLast()
        return paths.joinWithSeparator("/")
    }
}

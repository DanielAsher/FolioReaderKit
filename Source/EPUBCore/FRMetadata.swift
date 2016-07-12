//
//  FRMetadata.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 04/05/15.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import UIKit

/**
Represents one of the authors of the book.
*/
public struct Author {
    public var name: String!
    public var role: String!
    public var fileAs: String!
    
    init(name: String, role: String, fileAs: String) {
        self.name = name
        self.role = role
        self.fileAs = fileAs
    }
}

/**
A Book's identifier.
*/
public struct Identifier {
    public var scheme: String!
    public var value: String!
    
    init(scheme: String, value: String) {
        self.scheme = scheme
        self.value = value
    }
}

/**
A date and his event.
*/
public struct Date {
    public var date: String!
    public var event: String!
    
    init(date: String, event: String!) {
        self.date = date
        self.event = event
    }
}

/**
A metadata tag data.
*/
public struct Meta {
    public var name: String?
    public var content: String?
    public var id: String?
    public var property: String?
    public var value: String?
    public var refines: String?
    
    init(name: String, content: String) {
        self.name = name
        self.content = content
    }
    
    init(id: String, property: String, value: String) {
        self.id = id
        self.property = property
        self.value = value
    }

    init(property: String, value: String, refines: String!) {
        self.property = property
        self.value = value
        self.refines = refines
    }
}

/**
Manages book metadata.
*/
public class FRMetadata: NSObject {
    public var creators = [Author]()
    public var contributors = [Author]()
    public var dates = [Date]()
    public var language = "en"
    public var titles = [String]()
    public var identifiers = [Identifier]()
    public var subjects = [String]()
    public var descriptions = [String]()
    public var publishers = [String]()
    public var format = FRMediaType.EPUB.name
    public var rights = [String]()
    public var metaAttributes = [Meta]()
    
    func findMetaByName(name: String) -> String? {
        if name.isEmpty {
            return nil
        }
        
        for meta in metaAttributes {
            if meta.name != nil {
                if meta.name == name {
                    return meta.content
                }
            }
        }
        return nil
    }

    func findMetaByProperty(property: String, refinedBy: String?) -> String? {
        if property.isEmpty {
            return nil
        }

        for meta in metaAttributes {
            if meta.property != nil {
                if( meta.property == property && refinedBy == nil && meta.refines == nil){
                    return meta.value
                }
                if( meta.property == property && meta.refines == refinedBy){
                    return meta.value
                }
            }
        }
        return nil
    }

    func findMetaByProperty(property: String) -> String? {
        return findMetaByProperty(property, refinedBy: nil);
    }

}

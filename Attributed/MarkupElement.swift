//
//  MarkupElement.swift
//  Attributed
//
//  Created by Hilton Campbell on 12/9/15.
//  Copyright © 2015 Hilton Campbell. All rights reserved.
//

import Foundation

public struct MarkupElement {
    public let name: String
    public let attributes: [String: String]
    
    public init(name: String, attributes: [String: String]) {
        self.name = name
        self.attributes = attributes
    }
}

func ~= (pattern: String, element: MarkupElement) -> Bool {
    let scanner = NSScanner(string: pattern)
    scanner.charactersToBeSkipped = nil
    
    var name: NSString?
    if scanner.scanUpToString(".", intoString: &name), let name = name where name == element.name {
        if scanner.scanString(".", intoString: nil) {
            var className: NSString?
            if scanner.scanUpToString("", intoString: &className), let className = className where element.attributes["class"] == className {
                return true
            }
        } else {
            return true
        }
    }
    
    return false
}

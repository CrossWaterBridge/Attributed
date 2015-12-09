//
//  NSMutableAttributedString+SmallCaps.swift
//  LDSPonderize
//
//  Created by Hilton Campbell on 11/14/15.
//  Copyright © 2015 LDS Mobile Apps. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    public func simulateSmallCapsInRange(range: NSRange, withFont font: UIFont, attributes: [String: AnyObject]) {
        let replacement = NSMutableAttributedString()
        
        var smallAttributes = attributes
        smallAttributes[NSFontAttributeName] = font.fontWithSize(ceil(font.pointSize * 1.1 * font.xHeight / font.capHeight))
        
        let lowercaseCharacterSet = NSCharacterSet.lowercaseLetterCharacterSet()
        
        let scanner = NSScanner(string: attributedSubstringFromRange(range).string)
        scanner.charactersToBeSkipped = nil
        while !scanner.atEnd {
            var value: NSString?
            if scanner.scanCharactersFromSet(lowercaseCharacterSet, intoString: &value), let value = value {
                replacement.appendAttributedString(NSAttributedString(string: value.uppercaseString, attributes: smallAttributes))
            }
            if scanner.scanUpToCharactersFromSet(lowercaseCharacterSet, intoString: &value), let value = value {
                replacement.appendAttributedString(NSAttributedString(string: value as String, attributes: attributes))
            }
        }
        
        replaceCharactersInRange(range, withAttributedString: replacement)
    }
    
}

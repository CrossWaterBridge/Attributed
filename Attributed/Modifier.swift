//
//  Modifier.swift
//  Attributed
//
//  Created by Hilton Campbell on 12/9/15.
//  Copyright © 2015 Hilton Campbell. All rights reserved.
//

import UIKit

public typealias Modifier = (mutableAttributedString: NSMutableAttributedString, range: NSRange, stack: [MarkupElement]) -> Void

public func modifierWithBaseAttributes(attributes: [String: AnyObject], modifiers: [Modifier]) -> Modifier {
    return { mutableAttributedString, range, stack in
        mutableAttributedString.addAttributes(attributes, range: range)
        for modifier in modifiers {
            modifier(mutableAttributedString: mutableAttributedString, range: range, stack: stack)
        }
    }
}

public typealias Map = (NSAttributedString) -> NSAttributedString

public func selectMap(selector: String, _ map: Map) -> Modifier {
    return { mutableAttributedString, range, stack in
        for element in stack {
            if selector ~= element {
                let attributedString = mutableAttributedString.attributedSubstringFromRange(range)
                mutableAttributedString.replaceCharactersInRange(range, withAttributedString: map(attributedString))
            }
        }
    }
}

public func bold(attributedString: NSAttributedString) -> NSAttributedString {
    if let result = attributedString.mutableCopy() as? NSMutableAttributedString {
        if let font = attributedString.attributesAtIndex(0, effectiveRange: nil)[NSFontAttributeName] as? UIFont {
            let range = NSMakeRange(0, attributedString.length)
            result.addAttribute(NSFontAttributeName, value: font.fontWithBold(), range: range)
        }
        return result
    }
    return attributedString
}

public func italic(attributedString: NSAttributedString) -> NSAttributedString {
    if let result = attributedString.mutableCopy() as? NSMutableAttributedString {
        if let font = attributedString.attributesAtIndex(0, effectiveRange: nil)[NSFontAttributeName] as? UIFont {
            let range = NSMakeRange(0, attributedString.length)
            result.addAttribute(NSFontAttributeName, value: font.fontWithItalic(), range: range)
        }
        return result
    }
    return attributedString
}

public func monospacedNumbers(attributedString: NSAttributedString) -> NSAttributedString {
    if let result = attributedString.mutableCopy() as? NSMutableAttributedString {
        if let font = attributedString.attributesAtIndex(0, effectiveRange: nil)[NSFontAttributeName] as? UIFont {
            let range = NSMakeRange(0, attributedString.length)
            result.addAttribute(NSFontAttributeName, value: font.fontWithMonospacedNumbers(), range: range)
        }
        return result
    }
    return attributedString
}

public func smallCaps(attributedString: NSAttributedString) -> NSAttributedString {
    if let result = attributedString.mutableCopy() as? NSMutableAttributedString {
        let attributes = attributedString.attributesAtIndex(0, effectiveRange: nil)
        if let font = attributes[NSFontAttributeName] as? UIFont {
            let range = NSMakeRange(0, attributedString.length)
            if font.supportsSmallCaps {
                result.addAttribute(NSFontAttributeName, value: font.fontWithSmallCaps(), range: range)
            } else {
                result.simulateSmallCapsInRange(range, withFont: font, attributes: attributes)
            }
        }
        return result
    }
    return attributedString
}

//
// Copyright (c) 2015 Hilton Campbell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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

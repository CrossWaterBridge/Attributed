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

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
    
    public func simulateSmallCapsInRange(_ range: NSRange, withFont font: UIFont, attributes: [String: Any]) {
        let replacement = NSMutableAttributedString()
        
        var smallAttributes = attributes
        smallAttributes[NSFontAttributeName] = font.withSize(ceil(font.pointSize * 1.1 * font.xHeight / font.capHeight))
        
        let lowercaseCharacterSet = CharacterSet.lowercaseLetters
        
        let scanner = Scanner(string: attributedSubstring(from: range).string)
        scanner.charactersToBeSkipped = nil
        while !scanner.isAtEnd {
            var value: NSString?
            if scanner.scanCharacters(from: lowercaseCharacterSet, into: &value), let value = value {
                replacement.append(NSAttributedString(string: value.uppercased, attributes: smallAttributes))
            }
            if scanner.scanUpToCharacters(from: lowercaseCharacterSet, into: &value), let value = value {
                replacement.append(NSAttributedString(string: value as String, attributes: attributes))
            }
        }
        
        replaceCharacters(in: range, with: replacement)
    }
    
}

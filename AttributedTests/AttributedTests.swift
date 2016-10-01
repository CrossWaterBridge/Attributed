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

import XCTest
@testable import Attributed

private let baseFont = UIFont.systemFont(ofSize: 10)
private let modifier: Modifier = modifierWithBaseAttributes([NSFontAttributeName: baseFont], modifiers: [
    selectMap("strong", bold),
    selectMap("br", lineBreak)
])

class AttributedTests: XCTestCase {
    func testEmpty() {
        let actual = NSAttributedString.attributedStringFromMarkup("", withModifier: modifier)
        let expected = NSAttributedString()
        XCTAssertEqual(actual, expected)
    }
    
    func testPlainText() {
        let actual = NSAttributedString.attributedStringFromMarkup("puppy", withModifier: modifier)
        let expected = NSAttributedString(string: "puppy", attributes: [NSFontAttributeName: baseFont])
        XCTAssertEqual(actual, expected)
    }
    
    func testElement() {
        let actual = NSAttributedString.attributedStringFromMarkup("kittens <strong>and</strong> puppies", withModifier: modifier)
        let expected = NSMutableAttributedString(string: "kittens ", attributes: [NSFontAttributeName: baseFont])
        expected.append(NSAttributedString(string: "and", attributes: [NSFontAttributeName: baseFont.fontWithBold()]))
        expected.append(NSAttributedString(string: " puppies", attributes: [NSFontAttributeName: baseFont]))
        XCTAssertEqual(actual, expected)
    }
    
    func testLineBreak() {
        let actual = NSAttributedString.attributedStringFromMarkup("kittens<br/>puppies", withModifier: modifier)
        let expected = NSAttributedString(string: "kittens\npuppies", attributes: [NSFontAttributeName: baseFont])
        XCTAssertEqual(actual, expected)
    }
}

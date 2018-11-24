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
import Attributed

private let baseFont = UIFont.systemFont(ofSize: 10)
private let boldFont = UIFont.boldSystemFont(ofSize: 10)
private let modifier: Modifier = modifierWithBaseAttributes([.font: baseFont], modifiers: [
    selectMap("regular", Modifiers.regular),
    selectMap("strong", Modifiers.bold),
    selectMap("p", Modifiers.para),
    selectMap("br", Modifiers.lineBreak),
    selectMapBefore("before", TestModifiers.marker),
    selectMapAfter("after", TestModifiers.marker),
    selectMap("widont", Modifiers.widont)
])

private enum TestModifiers {
    static func marker(_ context: NSAttributedString, _ attributedString: NSAttributedString) -> NSAttributedString {
        guard context.length > 0,
            let result = attributedString.mutableCopy() as? NSMutableAttributedString else { return attributedString }

        result.insert(NSAttributedString(string: "\n", attributes: context.attributes(at: context.length - 1, effectiveRange: nil)), at: attributedString.length)
        return result
    }
}

class AttributedTests: XCTestCase {
    func testEmpty() {
        let actual = NSAttributedString.attributedStringFromMarkup("", withModifier: modifier)
        let expected = NSAttributedString()
        XCTAssertEqual(actual, expected)
    }
    
    func testPlainText() {
        let actual = NSAttributedString.attributedStringFromMarkup("puppy", withModifier: modifier)
        let expected = NSAttributedString(string: "puppy", attributes: [.font: baseFont])
        XCTAssertEqual(actual, expected)
    }
    
    func testElement() {
        let actual = NSAttributedString.attributedStringFromMarkup("kittens <strong>and</strong> puppies", withModifier: modifier)
        let expected = NSMutableAttributedString(string: "kittens ", attributes: [.font: baseFont])
        expected.append(NSAttributedString(string: "and", attributes: [.font: boldFont]))
        expected.append(NSAttributedString(string: " puppies", attributes: [.font: baseFont]))
        XCTAssertEqual(actual, expected)
    }

    func testPara() {
        let actual = NSAttributedString.attributedStringFromMarkup("<p>kittens</p>puppies", withModifier: modifier)
        let expected = NSAttributedString(string: "kittens\npuppies", attributes: [.font: baseFont])
        XCTAssertEqual(actual, expected)
    }

    func testLineBreak() {
        let actual = NSAttributedString.attributedStringFromMarkup("kittens<br/>puppies", withModifier: modifier)
        let expected = NSAttributedString(string: "kittens\npuppies", attributes: [.font: baseFont])
        XCTAssertEqual(actual, expected)
    }

    func testBefore() {
        let actual = NSAttributedString.attributedStringFromMarkup("bunnies<before>kittens</before>puppies", withModifier: modifier)
        let expected = NSAttributedString(string: "bunnies\nkittenspuppies", attributes: [.font: baseFont])
        XCTAssertEqual(actual, expected)
    }

    func testNestedBefore() {
        let actual = NSAttributedString.attributedStringFromMarkup("bunnies<before>cats <strong>and</strong> kittens</before>puppies", withModifier: modifier)
        let expected = NSMutableAttributedString(string: "bunnies\ncats ", attributes: [.font: baseFont])
        expected.append(NSAttributedString(string: "and", attributes: [.font: boldFont]))
        expected.append(NSAttributedString(string: " kittenspuppies", attributes: [.font: baseFont]))
        XCTAssertEqual(actual, expected)
    }

    func testAfter() {
        let actual = NSAttributedString.attributedStringFromMarkup("bunnies<after>kittens</after>puppies", withModifier: modifier)
        let expected = NSAttributedString(string: "bunnieskittens\npuppies", attributes: [.font: baseFont])
        XCTAssertEqual(actual, expected)
    }

    func testNestedAfter() {
        let actual = NSAttributedString.attributedStringFromMarkup("bunnies<after>cats <strong>and</strong> kittens</after>puppies", withModifier: modifier)
        let expected = NSMutableAttributedString(string: "bunniescats ", attributes: [.font: baseFont])
        expected.append(NSAttributedString(string: "and", attributes: [.font: boldFont]))
        expected.append(NSAttributedString(string: " kittens\npuppies", attributes: [.font: baseFont]))
        XCTAssertEqual(actual, expected)
    }

    func testOrder() {
        let actual = NSAttributedString.attributedStringFromMarkup("<strong>kittens<regular>puppies</regular></strong>", withModifier: modifier)
        let expected = NSMutableAttributedString(string: "kittens", attributes: [.font: boldFont])
        expected.append(NSAttributedString(string: "puppies", attributes: [.font: baseFont]))
        XCTAssertEqual(actual, expected)
    }

    func testWidont() {
        let actual = NSAttributedString.attributedStringFromMarkup("<widont><p>bunnies, kittens, and puppies</p></widont>", withModifier: modifier)
        let expected = NSAttributedString(string: "bunnies, kittens, and\u{00a0}puppies\n", attributes: [.font: baseFont])
        XCTAssertEqual(actual, expected)
    }
}

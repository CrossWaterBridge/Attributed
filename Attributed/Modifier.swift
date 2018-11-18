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

import Foundation

public typealias Modifier = (_ mutableAttributedString: NSMutableAttributedString, _ range: NSRange, _ stack: [MarkupElement], _ startElement: MarkupElement?) -> Void

public func modifierWithBaseAttributes(_ attributes: [NSAttributedString.Key: Any], modifiers: [Modifier]) -> Modifier {
    return { mutableAttributedString, range, stack, startElement in
        mutableAttributedString.addAttributes(attributes, range: range)

        for count in 0...stack.count {
            let localStack = Array(stack[0..<count])
            for modifier in modifiers {
                modifier(mutableAttributedString, range, localStack, startElement)
            }
        }
    }
}

public typealias Map = (NSAttributedString) -> NSAttributedString

public func selectMap(_ selector: String, _ map: @escaping Map) -> Modifier {
    return { mutableAttributedString, range, stack, _ in
        guard let element = stack.last, selector ~= element else { return }

        let attributedString = mutableAttributedString.attributedSubstring(from: range)
        mutableAttributedString.replaceCharacters(in: range, with: map(attributedString))
    }
}

public func selectMapBefore(_ selector: String, _ map: @escaping Map) -> Modifier {
    return { mutableAttributedString, range, stack, startElement in
        guard let element = startElement, selector ~= element else { return }

        let attributedString = mutableAttributedString.attributedSubstring(from: range)
        mutableAttributedString.replaceCharacters(in: range, with: map(attributedString))
    }
}

public func selectMapAfter(_ selector: String, _ map: @escaping Map) -> Modifier {
    return { mutableAttributedString, range, stack, startElement in
        guard startElement == nil, let element = stack.last, selector ~= element else { return }

        let attributedString = mutableAttributedString.attributedSubstring(from: range)
        mutableAttributedString.replaceCharacters(in: range, with: map(attributedString))
    }
}

public typealias MapWithContext = (NSAttributedString, NSAttributedString) -> NSAttributedString

public func selectMap(_ selector: String, _ mapWithContext: @escaping MapWithContext) -> Modifier {
    return { mutableAttributedString, range, stack, _ in
        guard let element = stack.last, selector ~= element else { return }

        let attributedString = mutableAttributedString.attributedSubstring(from: range)
        mutableAttributedString.replaceCharacters(in: range, with: mapWithContext(mutableAttributedString, attributedString))
    }
}

public func selectMapBefore(_ selector: String, _ mapWithContext: @escaping MapWithContext) -> Modifier {
    return { mutableAttributedString, range, stack, startElement in
        guard let element = startElement, selector ~= element else { return }

        let attributedString = mutableAttributedString.attributedSubstring(from: range)
        mutableAttributedString.replaceCharacters(in: range, with: mapWithContext(mutableAttributedString, attributedString))
    }
}

public func selectMapAfter(_ selector: String, _ mapWithContext: @escaping MapWithContext) -> Modifier {
    return { mutableAttributedString, range, stack, startElement in
        guard startElement == nil, let element = stack.last, selector ~= element else { return }

        let attributedString = mutableAttributedString.attributedSubstring(from: range)
        mutableAttributedString.replaceCharacters(in: range, with: mapWithContext(mutableAttributedString, attributedString))
    }
}

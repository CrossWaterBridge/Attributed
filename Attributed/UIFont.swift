//
//  UIFont.swift
//  Attributed
//
//  Created by Hilton Campbell on 12/9/15.
//  Copyright © 2015 Hilton Campbell. All rights reserved.
//

import UIKit

extension UIFont {
    
    func fontWithBold() -> UIFont {
        return UIFont(descriptor: fontDescriptor().fontDescriptorWithSymbolicTraits(fontDescriptor().symbolicTraits.union(.TraitBold)), size: pointSize)
    }
    
    func fontWithItalic() -> UIFont {
        return UIFont(descriptor: fontDescriptor().fontDescriptorWithSymbolicTraits(fontDescriptor().symbolicTraits.union(.TraitItalic)), size: pointSize)
    }
    
    func fontWithMonospacedNumbers() -> UIFont {
        return UIFont(descriptor: fontDescriptor().fontDescriptorByAddingAttributes([
            UIFontDescriptorFeatureSettingsAttribute: [
                [
                    UIFontFeatureTypeIdentifierKey: kNumberSpacingType,
                    UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector,
                ],
            ],
            ]), size: pointSize)
    }
    
    var supportsSmallCaps: Bool {
        for feature in CTFontCopyFeatures(self) as NSArray? as? [[String: AnyObject]] ?? [] where feature[kCTFontFeatureTypeIdentifierKey as String] as? Int == kLowerCaseType {
            for featureSelector in feature[kCTFontFeatureTypeSelectorsKey as String] as? [[String: AnyObject]] ?? [] where featureSelector[kCTFontFeatureSelectorIdentifierKey as String] as? Int == kLowerCaseSmallCapsSelector {
                return true
            }
        }
        return false
    }
    
    func fontWithSmallCaps() -> UIFont {
        return UIFont(descriptor: fontDescriptor().fontDescriptorByAddingAttributes([
            UIFontDescriptorFeatureSettingsAttribute: [
                [
                    UIFontFeatureTypeIdentifierKey: kLowerCaseType,
                    UIFontFeatureSelectorIdentifierKey: kLowerCaseSmallCapsSelector,
                ],
            ],
        ]), size: pointSize)
    }
    
}

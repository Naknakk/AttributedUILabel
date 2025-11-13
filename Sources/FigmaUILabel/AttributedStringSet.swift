//
//  TextAttributeSet.swift
//  AttributedUILabel
//
//  Created by YunhakLee on 4/1/25.
//

import UIKit

struct AttributedStringSet {
    var label: FigmaUILabel
    var attributedString: NSMutableAttributedString
    
    init(label: FigmaUILabel, attributedString: NSMutableAttributedString) {
        self.label = label
        self.attributedString = attributedString
    }
}

// MARK: Basic
extension AttributedStringSet {
    func applyAttribute() {
        label.attributedText = attributedString
    }
}


// MARK: TextStyle
extension AttributedStringSet {
    private func baseParagraphStyle() -> NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = label.textAlignment
        style.lineBreakMode = label.lineBreakMode
        style.lineBreakStrategy = label.lineBreakStrategy
        style.allowsDefaultTighteningForTruncation = label.allowsDefaultTighteningForTruncation
        return style
    }
    
    func lineHeight(_ value: CGFloat?) -> AttributedStringSet {
        let length = attributedString.length
        let range = NSRange(location: 0, length: length)
        let style = baseParagraphStyle()
        
        if let lineHeight = value {
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            let offset = (lineHeight - label.font.lineHeight) / 2
            
            attributedString.addAttribute(.paragraphStyle,
                                          value: style,
                                          range: range)
            attributedString.addAttribute(.baselineOffset,
                                          value: offset,
                                          range: range)
        } else {
            attributedString.addAttribute(.paragraphStyle,
                                          value: style,
                                          range: range)
        }
        
        return self
    }
    
    func kerning(_ value: CGFloat?) -> AttributedStringSet {
        let length = attributedString.length
        let range = NSRange(location: 0, length: length)
        
        if let kerning = value {
            attributedString.addAttribute(.kern,
                                          value: kerning,
                                          range: range)
        } else {
            attributedString.removeAttribute(.kern,
                                             range: range)
        }
        
        return self
    }
    
    func underlineStyle(_ style: NSUnderlineStyle?) -> AttributedStringSet {
        let length = attributedString.length
        let range = NSRange(location: 0, length: length)
        
        if let style {
            attributedString.addAttribute(.underlineStyle,
                                          value: style.rawValue,
                                          range: range)
        } else {
            attributedString.removeAttribute(.underlineStyle,
                                             range: range)
        }
        
        return self
    }
    
}

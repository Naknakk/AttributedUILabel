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
        self.label.attributedText = self.attributedString
    }
}


// MARK: TextStyle
extension AttributedStringSet {
    private func baseParagraphStyle() -> NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = self.label.textAlignment
        style.lineBreakMode = self.label.lineBreakMode
        style.lineBreakStrategy = self.label.lineBreakStrategy
        style.allowsDefaultTighteningForTruncation = self.label.allowsDefaultTighteningForTruncation
        return style
    }
    
    func lineHeight(_ value: CGFloat?) -> AttributedStringSet {
        let length = self.attributedString.length
        guard length >= 1 else { return self }
        
        let style = baseParagraphStyle()
        
        if let lineHeight = value {
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            self.attributedString.addAttribute(
                .paragraphStyle,
                value: style,
                range: NSRange(location: 0, length: length)
            )
            
            self.attributedString.addAttribute(
                .baselineOffset,
                value: (lineHeight - self.label.font.lineHeight) / 2,
                range: NSRange(location: 0, length: length)
            )
        } else {
            self.attributedString.addAttribute(
                .paragraphStyle,
                value: style,
                range: NSRange(location: 0, length: length)
            )
        }
        
        return self
    }
    
    func kerning(_ value: CGFloat?) -> AttributedStringSet {
        let length = self.attributedString.length
        guard length > 1 else { return self }
        guard let kerning = value else { return self }
        
        self.attributedString.addAttribute(
            .kern,
            value: kerning,
            range: NSRange(location: 0, length: length)
        )
        
        return self
    }
    
    func underlineStyle(_ style: NSUnderlineStyle?) -> AttributedStringSet {
        let length = self.attributedString.length
        
        self.attributedString.addAttribute(
            .underlineStyle,
            value: style?.rawValue,
            range: NSRange(location: 0, length: length)
        )
        
        return self
    }
}

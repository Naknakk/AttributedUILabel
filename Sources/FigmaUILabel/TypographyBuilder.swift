//
//  TypographyBuilder.swift
//  FigmaUILabel
//
//  Created by YunhakLee on 4/1/25.
//

import UIKit

struct TypographyBuilder {
    var label: UILabel
    var attributedString: NSMutableAttributedString
    
    init(label: UILabel, attributedString: NSMutableAttributedString) {
        self.label = label
        self.attributedString = attributedString
    }
}

// MARK: Basic
extension TypographyBuilder {
    func applyAttribute() {
        label.attributedText = attributedString
    }
}


// MARK: TextStyle
extension TypographyBuilder {
    private func baseParagraphStyle() -> NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = label.textAlignment
        style.lineBreakMode = label.lineBreakMode
        style.lineBreakStrategy = label.lineBreakStrategy
        style.allowsDefaultTighteningForTruncation = label.allowsDefaultTighteningForTruncation
        return style
    }
    
    func lineHeight(_ value: CGFloat?) -> TypographyBuilder {
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
    
    func kerning(_ value: CGFloat?) -> TypographyBuilder {
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
    
    func underlineStyle(_ style: NSUnderlineStyle?) -> TypographyBuilder {
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

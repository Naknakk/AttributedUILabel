//
//  Logger.swift
//  FigmaUILabel
//
//  Created by YunhakLee on 11/13/25.
//

import UIKit

final internal class Logger {
    internal static func debugPrintAllAttributes(of label: UILabel, tag: String) {
        guard let attr = label.attributedText else {
            print("[\(tag)] no attributedText")
            return
        }
        
        print("════ [\(tag)] attributedText dump (length: \(attr.length)) ════")
        let full = NSRange(location: 0, length: attr.length)
        
        attr.enumerateAttributes(in: full, options: []) { attrs, range, _ in
            print("range: \(range)")
            Self.debugPrintAttributes(attrs, tag: tag)
        }
    }
    
    internal static func debugPrintAttributes(_ attrs: [NSAttributedString.Key: Any], tag: String) {
        print("──── [\(tag)] attributes ────")
        
        for key in attrs.keys.sorted(by: { $0.rawValue < $1.rawValue }) {
            guard let value = attrs[key] else { continue }
            switch key {
            case .font:
                if let font = value as? UIFont {
                    print("• font: \(font.fontName), size: \(font.pointSize)")
                } else {
                    print("• font: \(value)")
                }
                
            case .foregroundColor:
                if let color = value as? UIColor {
                    print("• foregroundColor: \(color)")
                } else {
                    print("• foregroundColor: \(value)")
                }
                
            case .kern:
                print("• kern: \(value)")
                
            case .underlineStyle:
                if let raw = value as? Int,
                   let style = NSUnderlineStyle(rawValue: raw) as NSUnderlineStyle? {
                    print("• underlineStyle: \(style) (raw: \(raw))")
                } else {
                    print("• underlineStyle: \(value)")
                }
                
            case .paragraphStyle:
                if let style = value as? NSParagraphStyle {
                    print("• paragraphStyle:")
                    print("    - alignment: \(style.alignment)")
                    print("    - lineBreakMode: \(style.lineBreakMode)")
                    print("    - lineBreakStrategy: \(style.lineBreakStrategy)")
                    print("    - minLineHeight: \(style.minimumLineHeight)")
                    print("    - maxLineHeight: \(style.maximumLineHeight)")
                    print("    - lineSpacing: \(style.lineSpacing)")
                    print("    - paragraphSpacing: \(style.paragraphSpacing)")
                } else {
                    print("• paragraphStyle: \(value)")
                }
                
            default:
                print("• \(key.rawValue): \(value)")
            }
        }
        
        print("──────────────────────────────")
    }
}

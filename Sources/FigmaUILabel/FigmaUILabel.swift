//
//  FigmaUILabel.swift
//  FigmaUILabel
//
//  Created by YunhakLee on 11/12/25.
//

import UIKit

public final class FigmaUILabel: UILabel {
    private var needsTextStyleUpdate = false
    
    public override var text: String? { didSet { setNeedsTextStyleUpdate() } }
    public override var font: UIFont! { didSet { setNeedsTextStyleUpdate() } }
    public override var textAlignment: NSTextAlignment { didSet { setNeedsTextStyleUpdate() } }
    public override var lineBreakMode: NSLineBreakMode { didSet { setNeedsTextStyleUpdate() } }
    public override var allowsDefaultTighteningForTruncation: Bool { didSet { setNeedsTextStyleUpdate() } }
    public override var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy { didSet { setNeedsTextStyleUpdate() } }
    
    public var lineHeight: FigmaMetric = .natural { didSet { setNeedsTextStyleUpdate() } }
    public var kerning: FigmaMetric = .natural { didSet { setNeedsTextStyleUpdate() } }
    public var underlineStyle: NSUnderlineStyle? { didSet { setNeedsTextStyleUpdate() } }
    
    private func setNeedsTextStyleUpdate() {
        guard !needsTextStyleUpdate else { return }
        needsTextStyleUpdate = true
        
        DispatchQueue.main.async { [weak self] in
            self?.updateTextStyleIfNeeded()
            self?.needsTextStyleUpdate = false
        }
    }
    
    private func updateTextStyleIfNeeded() {
        debugPrintUnderline(self, tag: "before builder")
        
        TextStyleBuilder(self)
            .lineHeight(lineHeight.resolvedValue(for: font))
            .kerning(kerning.resolvedValue(for: font))
            .underlineStyle(underlineStyle)
            .apply()
        
        debugPrintUnderline(self, tag: "after builder")
    }
    private func debugPrintUnderline(_ label: UILabel, tag: String) {
        guard let attr = label.attributedText else {
            print("[\(tag)] no attributedText")
            return
        }
        let length = attr.length
        let attrs = attr.attributes(at: 0, effectiveRange: nil)
        print("[\(tag)] length: \(length), attrs[0]: \(attrs)")
    }
}


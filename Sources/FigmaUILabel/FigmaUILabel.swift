//
//  FigmaUILabel.swift
//  FigmaUILabel
//
//  Created by YunhakLee on 11/12/25.
//

import UIKit

public final class FigmaUILabel: UILabel {
    //MARK: Label Properties
    public override var text: String? { didSet { setNeedsTextStyleUpdate() } }
    public override var font: UIFont! { didSet { setNeedsTextStyleUpdate() } }
    public override var textAlignment: NSTextAlignment { didSet { setNeedsTextStyleUpdate() } }
    public override var lineBreakMode: NSLineBreakMode { didSet { setNeedsTextStyleUpdate() } }
    public override var allowsDefaultTighteningForTruncation: Bool { didSet { setNeedsTextStyleUpdate() } }
    public override var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy { didSet { setNeedsTextStyleUpdate() } }
    
    public var lineHeight: FigmaMetric = .natural { didSet { setNeedsTextStyleUpdate() } }
    public var kerning: FigmaMetric = .natural { didSet { setNeedsTextStyleUpdate() } }
    public var underlineStyle: NSUnderlineStyle? { didSet { setNeedsTextStyleUpdate() } }
    
    //MARK: TextStyle Update
    private var needsTextStyleUpdate = false
    
    private func setNeedsTextStyleUpdate() {
        guard !needsTextStyleUpdate else { return }
        needsTextStyleUpdate = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.updateTextStyleIfNeeded()
            self.needsTextStyleUpdate = false
        }
    }
    
    private func updateTextStyleIfNeeded() {
        TextStyleBuilder(self)
            .lineHeight(lineHeight.resolvedValue(for: font))
            .kerning(kerning.resolvedValue(for: font))
            .underlineStyle(underlineStyle)
            .apply()
    }
    
    func debugUnderlineRuns(_ label: UILabel, tag: String) {
        guard let attr = label.attributedText else {
            print("[\(tag)] no attributedText")
            return
        }

        let fullRange = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.underlineStyle,
                                in: fullRange,
                                options: []) { value, range, _ in
            print("[\(tag)] underline attr in range \(range): \(String(describing: value))")
        }
    }
}


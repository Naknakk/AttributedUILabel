//
//  FigmaUILabel.swift
//  FigmaUILabel
//
//  Created by YunhakLee on 11/12/25.
//

import UIKit

public final class FigmaUILabel: UILabel {
    public override var text: String? { didSet { updateLabel() } }
    public override var font: UIFont! { didSet { updateLabel() } }
    public override var textAlignment: NSTextAlignment { didSet { updateLabel() } }
    public override var lineBreakMode: NSLineBreakMode { didSet { updateLabel() } }
    public override var allowsDefaultTighteningForTruncation: Bool { didSet { updateLabel() } }
    public override var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy { didSet { updateLabel() } }
    
    public var lineHeight: FigmaMetric = .natural { didSet { updateLabel() } }
    public var kerning: FigmaMetric = .natural { didSet { updateLabel() } }
    public var underlineStyle: NSUnderlineStyle? { didSet { updateLabel() } }
    
    private var isUpdating = false
    
    private func updateLabel() {
        guard !isUpdating else { return }
        isUpdating = true
        defer { isUpdating = false }
        self.makeAttribute(with: self.text)?
            .lineHeight(lineHeight.resolvedValue(for: self.font))
            .kerning(kerning.resolvedValue(for: self.font))
            .underlineStyle(underlineStyle)
            .applyAttribute()
    }
}

extension FigmaUILabel {
    private func makeAttribute(with text: String?) -> AttributedStringSet? {
        guard let text = text, !text.isEmpty else { return nil }
        
        let attributedStringSet = AttributedStringSet(
            label: self,
            attributedString: NSMutableAttributedString(string: text)
        )
        
        return attributedStringSet
    }
}

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
}

// MARK: - Update cycle
extension FigmaUILabel {
    private func setNeedsTextStyleUpdate() {
        needsTextStyleUpdate = true
        setNeedsLayout()          // 👉 다음 레이아웃 사이클에서 한 번에 처리
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateTextStyleIfNeeded()
    }

    private func updateTextStyleIfNeeded() {
        guard needsTextStyleUpdate else { return }
        
        TextStyleBuilder(self)
            .lineHeight(lineHeight.resolvedValue(for: font))
            .kerning(kerning.resolvedValue(for: font))
            .underlineStyle(underlineStyle)
            .apply()
        
        needsTextStyleUpdate = false
    }
}

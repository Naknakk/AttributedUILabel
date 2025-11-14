//
//  FigmaUILabel.swift
//  FigmaUILabel
//
//  Created by YunhakLee on 11/12/25.
//

import UIKit

public final class FigmaUILabel: UILabel {
    //MARK: Label Properties
    public override var text: String? { didSet { updateTextStyle() } }
    public override var font: UIFont! { didSet { updateTextStyle() } }
    public override var textAlignment: NSTextAlignment { didSet { updateTextStyle() } }
    public override var lineBreakMode: NSLineBreakMode { didSet { updateTextStyle() } }
    public override var allowsDefaultTighteningForTruncation: Bool { didSet { updateTextStyle() } }
    public override var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy { didSet { updateTextStyle() } }
    
    public var lineHeight: FigmaMetric = .natural { didSet { updateTextStyle() } }
    public var kerning: FigmaMetric = .natural { didSet { updateTextStyle() } }
    public var underlineStyle: NSUnderlineStyle? { didSet { updateTextStyle() } }
}

// MARK: - Update cycle
extension FigmaUILabel {
    private func updateTextStyle() {
        TextStyleBuilder(self)
            .lineHeight(lineHeight.resolvedValue(for: font))
            .kerning(kerning.resolvedValue(for: font))
            .underlineStyle(underlineStyle)
            .apply()

    }
}

//
//  FigmaMetric.swift
//  FigmaUILabel
//
//  Created by YunhakLee on 11/12/25.
//

import UIKit

public enum FigmaMetric {
    case natural
    case percent(Double)
    case point(CGFloat)
    
    public func resolvedValue(for baseFont: UIFont) -> CGFloat? {
        switch self {
        case .natural: return nil
        case .percent(let p): return baseFont.pointSize * CGFloat(p / 100.0)
        case .point(let pt): return pt
        }
    }
}

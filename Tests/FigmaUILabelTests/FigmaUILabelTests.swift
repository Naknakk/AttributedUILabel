import XCTest
@testable import FigmaUILabel   // 모듈 이름에 맞게 맞추기

final class FigmaUILabelTests: XCTestCase {

    // MARK: - Helpers
    
    /// 메인 큐 async(= coalescing) 처리가 끝날 시간을 조금 줌
    private func pumpRunLoop() {
        RunLoop.current.run(until: Date().addingTimeInterval(0.01))
    }
    
    /// 공통 설정이 들어간 기본 라벨 생성
    private func makeLabel(fontSize: CGFloat = 16) -> FigmaUILabel {
        let label = FigmaUILabel()
        label.font = .systemFont(ofSize: fontSize)
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.lineBreakStrategy = .hangulWordPriority
        label.allowsDefaultTighteningForTruncation = false
        return label
    }
    
    /// 첫 글자 기준 attribute 헬퍼
    private func attributes(of label: UILabel) -> [NSAttributedString.Key: Any] {
        guard let attributedText = label.attributedText else {
            XCTFail("attributedText가 nil입니다")
            return [:]
        }
        return attributedText.attributes(at: 0, effectiveRange: nil)
    }
    
    private func paragraph(from attrs: [NSAttributedString.Key: Any]) -> NSParagraphStyle? {
        attrs[.paragraphStyle] as? NSParagraphStyle
    }
    
    private func kern(from attrs: [NSAttributedString.Key: Any]) -> CGFloat? {
        attrs[.kern] as? CGFloat
    }
    
    private func underline(from attrs: [NSAttributedString.Key: Any]) -> Int? {
        attrs[.underlineStyle] as? Int
    }
    
    // MARK: - Text 변경 시 TextStyle 자동 적용
    
    /// 한 번 설정한 lineHeight / kerning / underlineStyle 이 나중에 text를 바꿔도 동일하게 유지되는지 확인
    func testTextChangeKeepsTextStyleAttributes() {
        // given
        let label = makeLabel(fontSize: 16)
        
        label.lineHeight = .percent(140)      // 140%
        label.kerning = .point(0.8)           // 0.8pt
        label.underlineStyle = .single
        label.text = "Hello FigmaUILabel"
        pumpRunLoop()
        
        // when: 텍스트만 변경
        label.text = "텍스트가 변경된 이후에도 스타일이 유지되어야 합니다."
        pumpRunLoop()
        
        // then
        let attrs = attributes(of: label)
        
        if let paragraph = paragraph(from: attrs) {
            let expectedLineHeight = label.font.pointSize * 1.4    // 140%
            XCTAssertEqual(paragraph.minimumLineHeight, expectedLineHeight, accuracy: 0.001)
            XCTAssertEqual(paragraph.maximumLineHeight, expectedLineHeight, accuracy: 0.001)
        } else {
            XCTFail("paragraphStyle이 설정되어 있지 않습니다")
        }
        
        if let kern = kern(from: attrs) {
            XCTAssertEqual(kern, 0.8, accuracy: 0.001)
        } else {
            XCTFail("kerning(.kern)이 설정되어 있지 않습니다")
        }
        
        if let underline = underline(from: attrs) {
            XCTAssertEqual(underline, NSUnderlineStyle.single.rawValue)
        } else {
            XCTFail("underlineStyle이 설정되어 있지 않습니다")
        }
    }

    /// Figma 스타일을 한 번 설정하고 → 다시 다른 값으로 바꾼 뒤 → text를 바꾸면 “마지막 스타일 값”이 적용되는지 검증.
    func testChangingTextStyleThenTextUsesLatestAttributes() {
        // given
        let label = makeLabel(fontSize: 18)

        label.lineHeight = .percent(120)
        label.kerning = .point(0.0)
        label.underlineStyle = nil
        label.text = "초기 텍스트"
        pumpRunLoop()

        // when: 스타일을 바꾸고 그 다음에 텍스트를 바꿈
        label.lineHeight = .percent(180)
        label.kerning = .point(-0.5)
        label.underlineStyle = .single
        label.text = "스타일 변경 후 텍스트"
        pumpRunLoop()

        // then
        let attrs = attributes(of: label)

        if let paragraph = paragraph(from: attrs) {
            let expectedLineHeight = label.font.pointSize * 1.8    // 180%
            XCTAssertEqual(paragraph.minimumLineHeight, expectedLineHeight, accuracy: 0.001)
            XCTAssertEqual(paragraph.maximumLineHeight, expectedLineHeight, accuracy: 0.001)
        } else {
            XCTFail("paragraphStyle이 설정되어 있지 않습니다")
        }

        if let kern = kern(from: attrs) {
            XCTAssertEqual(kern, -0.5, accuracy: 0.001)
        } else {
            XCTFail("kerning(.kern)이 설정되어 있지 않습니다")
        }

        if let underline = underline(from: attrs) {
            XCTAssertEqual(underline, NSUnderlineStyle.single.rawValue)
        } else {
            XCTFail("underlineStyle이 설정되어 있지 않습니다")
        }
    }
    
    // MARK: - UIKit 속성 보존
    
    /// non-attributed 속성들이 텍스트 변경 후에도 그대로 유지되는지 확인 (TextStyleBuilder가 UILabel 기본 프로퍼티를 건드리지 않는지 검증)
    func testNonAttributedPropertiesArePreservedAfterTextChange() {
        // given
        let label = makeLabel(fontSize: 17)
        
        label.textColor = .systemRed
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.lineBreakStrategy = .hangulWordPriority
        label.allowsDefaultTighteningForTruncation = true
        
        label.lineHeight = .percent(150)
        label.kerning = .point(1.2)
        label.underlineStyle = .single
        label.text = "처음 텍스트"
        pumpRunLoop()
        
        // when: 텍스트만 변경
        label.text = "텍스트를 변경해도 UIKit 속성이 유지돼야 합니다."
        pumpRunLoop()
        
        // then
        XCTAssertEqual(label.textColor, .systemRed)
        XCTAssertEqual(label.textAlignment, .center)
        XCTAssertEqual(label.lineBreakMode, .byTruncatingTail)
        XCTAssertEqual(label.lineBreakStrategy, .hangulWordPriority)
        XCTAssertEqual(label.allowsDefaultTighteningForTruncation, true)
        
        // paragraphStyle도 label 설정을 따라갔는지
        let attrs = attributes(of: label)
        if let paragraph = paragraph(from: attrs) {
            XCTAssertEqual(paragraph.alignment, .center)
            XCTAssertEqual(paragraph.lineBreakMode, .byTruncatingTail)
            XCTAssertEqual(paragraph.lineBreakStrategy, .hangulWordPriority)
        } else {
            XCTFail("paragraphStyle이 설정되어 있지 않습니다")
        }
    }
    
    /// Figma 텍스트 스타일(lineHeight / kerning / underlineStyle)을 바꿔도 UIKit 쪽 속성(textColor / alignment / lineBreakMode 등)은 그대로 유지되는지
    func testChangingTextStyleDoesNotAffectUIKitProperties() {
        // given
        let label = makeLabel(fontSize: 17)
        
        label.textColor = .systemBlue
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingMiddle
        label.lineBreakStrategy = .hangulWordPriority
        label.allowsDefaultTighteningForTruncation = true
        
        label.lineHeight = .percent(120)
        label.kerning = .point(0.5)
        label.underlineStyle = nil
        label.text = "초기 텍스트"
        pumpRunLoop()
        
        // when: Figma 텍스트 스타일만 변경
        label.lineHeight = .percent(180)
        label.kerning = .point(-0.8)
        label.underlineStyle = .single
        pumpRunLoop()
        
        // then: UIKit 쪽 속성들은 그대로 유지되어야 함
        XCTAssertEqual(label.textColor, .systemBlue)
        XCTAssertEqual(label.textAlignment, .right)
        XCTAssertEqual(label.lineBreakMode, .byTruncatingMiddle)
        XCTAssertEqual(label.lineBreakStrategy, .hangulWordPriority)
        XCTAssertEqual(label.allowsDefaultTighteningForTruncation, true)
    }
    
    // MARK: - FigmaMetric / 에지 케이스
    
    /// FigmaMetric.percent / .point 해석이 올바른지 단위 테스트
    func testFigmaMetricResolution() {
        let font = UIFont.systemFont(ofSize: 20)

        // percent는 non-nil이어야 한다
        let percent = FigmaMetric.percent(150).resolvedValue(for: font)
        XCTAssertNotNil(percent, "percent(150)은 nil이면 안 됩니다")
        if let percent {
            // 20 * 1.5 = 30
            XCTAssertEqual(percent, 30, accuracy: 0.001)
        }

        // point도 non-nil이어야 한다
        let point = FigmaMetric.point(12).resolvedValue(for: font)
        XCTAssertNotNil(point, "point(12)는 nil이면 안 됩니다")
        if let point {
            XCTAssertEqual(point, 12, accuracy: 0.001)
        }

        // natural은 항상 nil이어야 한다
        XCTAssertNil(FigmaMetric.natural.resolvedValue(for: font),
                     "natural은 항상 nil이어야 합니다")
    }
    
    /// underlineStyle을 nil로 바꾸면 underline attribute가 제거되는지 확인
    func testUnderlineStyleNilRemovesUnderlineAttribute() {
        let label = makeLabel()
        
        label.underlineStyle = .single
        label.text = "밑줄 있음"
        pumpRunLoop()
        
        var attrs = attributes(of: label)
        XCTAssertNotEqual(underline(from: attrs), 0, "초기에는 underline이 있어야 합니다")
        
        // when: underline 제거
        label.underlineStyle = nil
        label.text = "밑줄 제거"
        pumpRunLoop()
        
        attrs = attributes(of: label)
        XCTAssertEqual(underline(from: attrs), 0, "underlineStyle을 nil로 바꾸면 underline attribute가 0으로 설정되어야 합니다")
    }
    
    /// 빈 문자열 / nil 텍스트에서도 크래시 없이 동작하는지, 스타일 적용 로직이 안전한지 확인
    func testEmptyAndNilTextAreHandledSafely() {
        let label = makeLabel()
        
        label.lineHeight = .percent(140)
        label.kerning = .point(0.5)
        label.underlineStyle = .single
        
        // empty string
        label.text = ""
        pumpRunLoop()
        XCTAssertNotNil(label.attributedText, "빈 문자열이어도 attributedText는 비어 있는 상태로 생성될 수 있습니다")
        
        // nil text
        label.text = nil
        pumpRunLoop()
        // 구현에 따라 nil or empty 둘 중 하나를 허용
        XCTAssertNotNil(label.attributedText, "빈 문자열이어도 attributedText는 비어 있는 상태로 생성될 수 있습니다")
    }
}

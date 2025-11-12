import XCTest
@testable import FigmaUILabel

final class AttributedUILabelTests: XCTestCase {
    func testWillSetIsCalled() {
        // Given: AttributedUILabel 인스턴스 생성
        let label = FigmaUILabel(frame: .zero)
        
        // When: text 값을 변경
        label.text = "First Text"
        
        // Then: 콘솔 출력 확인 (디버깅용)
        label.text = "Second Text" // "text Will Change"가 출력되어야 합니다.
        
        // Assert: 새로운 텍스트 값이 올바르게 설정되었는지 확인
        XCTAssertEqual(label.text, "Second Text")
    }
}

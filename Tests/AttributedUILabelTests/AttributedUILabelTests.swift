import XCTest
@testable import AttributedUILabel

final class AttributedUILabelTests: XCTestCase {
    func testGreet() {
        XCTAssertEqual(greet(name: "World"), "Hello, World!")
    }
}

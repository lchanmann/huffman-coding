import XCTest
@testable import HuffmanCoding

final class HuffmanCodingTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HuffmanCoding().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

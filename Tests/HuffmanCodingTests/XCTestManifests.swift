import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HuffmanCodingTests.allTests),
    ]
}
#endif

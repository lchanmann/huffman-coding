import XCTest
@testable import HuffmanCoding

final class HuffmanCodingTests: XCTestCase {
    static var allTests = [
        ("testHuffmanEncode", testHuffmanEncode),
        ("testHuffmanDecode", testHuffmanDecode),
        ("testHuffmanEncodeAsString_and_Decode", testHuffmanEncodeAsString_and_Decode),
        ("testHuffmanEncode_singleCharactersString", testHuffmanEncode_singleCharactersString),
    ]

    func testHuffmanEncode() {
        let str = "Huffman"
        let freq = str.reduce(into: [:]) { ret, c in ret[c, default: 0] += 1 }
        let huffman = Huffman(freq: freq)

        let (data, size) = huffman.encode(str)
        XCTAssertEqual(data.count, 3)
        XCTAssertEqual(size, 18)
    }

    func testHuffmanDecode() {
        let str = "Huffman"
        let freq = str.reduce(into: [:]) { ret, c in ret[c, default: 0] += 1 }
        let huffman = Huffman(freq: freq)

        let (data, size) = huffman.encode(str)
        XCTAssertEqual(huffman.decode(bytes: data, size: size), str)
    }

    func testHuffmanEncodeAsString_and_Decode() {
        let str = "Huffman"
        let freq = str.reduce(into: [:]) { ret, c in ret[c, default: 0] += 1 }
        let huffman = Huffman(freq: freq)

        let code = huffman.encodeAsString(str)
        XCTAssertEqual(huffman.decode(code), str)
    }

    func testHuffmanEncode_singleCharactersString() {
        let str = "AAAAA"
        let freq = str.reduce(into: [:]) { ret, c in ret[c, default: 0] += 1 }
        let huffman = Huffman(freq: freq)

        let (data, size) = huffman.encode(str)
        XCTAssertEqual(huffman.decode(bytes: data, size: size), str)
        XCTAssertTrue(size / 8 < str.count)
    }
}

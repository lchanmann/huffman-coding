import Foundation

/// Huffman coding - https://en.wikipedia.org/wiki/Huffman_coding
///
/// Huffman's algorithm can be viewed as a variable-length code table for mapping
/// the characters in the source text into their representative bits (0s & 1s)
/// found in the table.
///
/// The table is derived from the estimated frequency of occurrence of each
/// possible character i.e, the distribution of the character.
///
/// The better matching between the distribution and the data to be encoded the
/// better compression efficiency yielded. The saving/compression comes from the
/// fact that characters are encoded with less bits especially the most frequently
/// used ones.
///
/// Example usage:
///
///     let str = "Huffman"
///     let freq = str.reduce(into: [:]) { ret, c in ret[c, default: 0] += 1 }
///     let huffman = Huffman(freq: freq)
///     let (data, size) = huffman.encode(str)
///
///     // Decode
///     let text = huffman.decode(bytes: data, size: size)
///
/// The above encoded data is an array of three 8-bit integers which consume 3 bytes
/// while the original text needs 7 bytes to store. The `size' constant informs the
/// number of bits needed for the encoded data.
struct Huffman {
    private var nodes: [Node]
    
    /// Huffman tree
    var tree: Node { return nodes[0] }
    
    /// Cached Huffman codec for encoding
    var codec = [Character: String]()
    
    /// Cached inverse codec for decoding
    var inverseCodec = [String: Character]()
    
    init(freq: [Character: Int]) {
        nodes = freq.sorted(by: { $0.value < $1.value })
                    .reduce(into: []) { ret, item in ret.append(Node(data: item.key, freq: item.value)) }
        buildTree()
        generateCodec(tree, code: "")
    }
    
    private mutating func buildTree() {
        while nodes.count > 1 {
            let left = nodes.removeFirst()
            let right = nodes.removeFirst()
            let parent = left + right
                
            insertParent:
            if nodes.isEmpty {
                nodes.append(parent)
            } else {
                for (index, node) in nodes.enumerated() {
                    if node.freq < parent.freq { continue }
                    nodes.insert(parent, at: index)
                    break insertParent
                }
                nodes.append(parent)
            }
        }
    }
    
    private mutating func generateCodec(_ node: Node, code: String) {
        if let c = node.data {
            codec[c] = !code.isEmpty ? code : "0"
            inverseCodec[codec[c]!] = c
        } else {
            generateCodec(node.left!, code: code + "0")
            generateCodec(node.right!, code: code + "1")
        }
    }
    
    /// Encode text string to Huffman code byte array
    func encode(_ str: String) -> ([UInt8], Int) {
        let binary = str.map { codec[$0]! }.joined()
        return (toBytes(binary), binary.count)
    }
    
    /// Encode text string to Huffman code
    func encodeAsString(_ str: String) -> String {
        return str.map { codec[$0]! }.joined()
    }
    
    /// Decode Huffman code byte array to the original text
    func decode(bytes: [UInt8], size: Int) -> String {
        var binary = ""
        for byte in bytes {
            let s = String(byte, radix: 2)
            for _ in 0..<(8 - s.count) { binary.append("0") }
            binary.append(s)
        }
        let startIndex = binary.index(binary.endIndex, offsetBy: -size)
        return decode(String(binary[startIndex...]))
    }
    
    /// Decode Huffman code back to the original text
    func decode(_ str: String) -> String {
        var result = ""
        var code = ""
        
        for d in str {
            code.append(d)
            if let c = inverseCodec[code] {
                result.append(c)
                code.removeAll(keepingCapacity: true)
            }
        }
        return result
    }
    
    /// Convert string of 0s & 1s to 8-bit byte array
    private func toBytes(_ str: String) -> [UInt8] {
        var bytes = [UInt8]()
        for (i, d) in str.reversed().enumerated() {
            let value: UInt8 = d == "1" ? UInt8(pow(2, Double(i % 8))) : 0
            
            if i % 8 == 0 { bytes.insert(value, at: 0) }
            else { bytes[0] += value }
        }
        return bytes
    }
    
    /// Huffman node data structure
    class Node: CustomStringConvertible {
        var description: String {
            return "\(self.data ?? "?"):\(self.freq)"
        }
        
        let data    : Character?
        var freq    : Int
        
        var left    : Node?
        var right   : Node?
        
        
        init(freq: Int) {
            self.data = nil
            self.freq = freq
        }
        
        init(data: Character, freq: Int) {
            self.data = data
            self.freq = freq
        }
        
        init(freq: Int, left: Node, right: Node) {
            self.data   = nil
            self.freq   = freq
            self.left   = left
            self.right  = right
        }
        
        static func + (left: Node, right: Node) -> Node {
            return Node(freq: left.freq + right.freq, left: left, right: right)
        }
    }
}

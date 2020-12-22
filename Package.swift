// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "huffman-coding",
    products: [
        .library(name: "HuffmanCoding", targets: ["HuffmanCoding"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "HuffmanCoding",
            dependencies: []
        ),
        .testTarget(
            name: "HuffmanCodingTests",
            dependencies: ["HuffmanCoding"]
        ),
    ]
)

// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "KanjiVGParser",
    platforms: [
        .macOS(.v15), .iOS(.v26)
    ],
    products: [
        .library(
            name: "KanjiVGParser",
            targets: ["KanjiVGParser"]
        ),
    ],
    targets: [
        .target(
            name: "KanjiVGParser",
            dependencies: []
        ),
    ]
)

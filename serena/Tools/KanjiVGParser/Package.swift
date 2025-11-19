// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "KanjiVGParser",
    platforms: [
        .macOS(.v15), .iOS(.v17),
    ],
    products: [
        .library(
            name: "KanjiVGParser",
            targets: ["KanjiVGParser"],
        ),
    ],
    targets: [
        .target(
            name: "KanjiVGParser",
            dependencies: [],
            resources: [
                .process("Resources"),
            ],
        ),
    ],
)

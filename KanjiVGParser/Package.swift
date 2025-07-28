// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "KanjiVGParser",
    products: [
        .library(
            name: "KanjiVGParser",
            targets: ["KanjiVGParser"]
        ),
    ],
    targets: [
        .target(
            name: "KanjiVGParser"
        ),

    ]
)

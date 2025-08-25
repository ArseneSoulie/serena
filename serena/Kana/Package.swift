// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Kana",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "Kana",
            targets: ["Kana"],
        ),
    ],
    dependencies: [
        .package(name: "Navigation", path: "./Navigation"),
        .package(name: "DesignSystem", path: "./DesignSystem"),
        .package(name: "FoundationModels", path: "./FoundationModels"),
        .package(name: "KanjiVGParser", path: "./KanjiVGParser"),
    ],
    targets: [
        .target(
            name: "Kana",
            dependencies: [
                "Navigation",
                "DesignSystem",
                "FoundationModels",
                "KanjiVGParser",
            ],
            resources: [
                .process("Resources"),
            ],
        ),
    ],
)

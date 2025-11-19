// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Training",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "Training",
            targets: ["Training"],
        ),
    ],
    dependencies: [
        .package(name: "Navigation", path: "../Navigation"),
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "FoundationModels", path: "../FoundationModels"),
        .package(name: "KanjiVGParser", path: "../KanjiVGParser"),
        .package(name: "Typist", path: "../Typist"),
    ],
    targets: [
        .target(
            name: "Training",
            dependencies: [
                "Navigation",
                "DesignSystem",
                "FoundationModels",
                "KanjiVGParser",
                "Typist",
            ],
            resources: [
                .process("Resources"),
            ],
        ),
    ],
)

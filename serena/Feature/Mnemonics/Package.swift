// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mnemonics",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "Mnemonics",
            targets: ["Mnemonics"],
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
            name: "Mnemonics",
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

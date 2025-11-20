// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Learn",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "Learn",
            targets: ["Learn"],
        ),
    ],
    dependencies: [
        .package(name: "Navigation", path: "../Navigation"),
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "FoundationModels", path: "../FoundationModels"),
    ],
    targets: [
        .target(
            name: "Learn",
            dependencies: [
                "Navigation",
                "DesignSystem",
                "FoundationModels",
            ],
            resources: [
                .process("Resources"),
            ],
        ),
    ],
)

// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Kana",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Kana",
            targets: ["Kana"]
        ),
    ],
    dependencies: [
        .package(name: "Helpers", path: "./Helpers"),
        .package(name: "Navigation", path: "./Navigation"),
        .package(name: "DesignSystem", path: "./DesignSystem"),
    ],
    targets: [
        .target(
            name: "Kana",
            dependencies: [
                "Navigation",
                "DesignSystem",
                "Helpers",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        
    ]
)

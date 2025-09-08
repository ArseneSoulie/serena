// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Typist",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "Typist",
            targets: ["Typist"],
        ),
    ],
    dependencies: [
        .package(name: "DesignSystem", path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "Typist",
            dependencies: [
                "DesignSystem",
            ],
        ),
    ],
)

// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "About",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "About",
            targets: ["About"],
        ),
    ],
    targets: [
        .target(
            name: "About",
            resources: [
                .process("Resources"),
            ],
        ),
    ],
)

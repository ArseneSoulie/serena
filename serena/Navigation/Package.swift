// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
    ],
    dependencies: [
        .package(name: "FoundationModels", path: "./FoundationModels"),
    ],
    targets: [
        .target(
            name: "Navigation",
            dependencies: [
                "FoundationModels"
            ]
        ),

    ]
)

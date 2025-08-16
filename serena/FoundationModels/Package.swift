// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FoundationModels",
    products: [
        .library(
            name: "FoundationModels",
            targets: ["FoundationModels"]
        ),
    ],
    targets: [
        .target(
            name: "FoundationModels"
        ),
    ]
)

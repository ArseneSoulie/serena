// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "JMdictTools",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.0"),
    ],
    targets: [
        .executableTarget(
            name: "JMdictTools",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources",
        ),
    ],
)

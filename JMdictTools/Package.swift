// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "JMdictTools",
    products: [
        .executable(name: "JMdictToolsCLI", targets: ["JMdictToolsCLI"]),
        .library(name: "JMdictTools", targets: ["JMdictToolsCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.0"),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "JMdictToolsCore",
            path: "Core",
        ),
        .executableTarget(
            name: "JMdictToolsCLI",
            dependencies: [
                "JMdictToolsCore",
                .product(name: "GRDB", package: "GRDB.swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "CLI",
        ),
    ],
)

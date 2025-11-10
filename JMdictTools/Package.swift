// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "JMdictTools",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
    ],
    products: [
        .executable(name: "jmdict-tools", targets: ["JMdictToolsCLI"]),
        .library(name: "ReinaDB", targets: ["ReinaDB"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.0"),
        .package(url: "https://github.com/pointfreeco/sqlite-data", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "ReinaDB",
            dependencies: [
                .product(name: "SQLiteData", package: "sqlite-data"),
            ],
            path: "ReinaDB",
        ),
        .executableTarget(
            name: "JMdictToolsCLI",
            dependencies: [
                "ReinaDB",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "CLI",
        ),
    ],
)

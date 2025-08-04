// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MetalShaders",
    platforms: [
        .macOS(.v15), .iOS(.v26)
    ],
    products: [
        .library(
            name: "MetalShaders",
            targets: ["MetalShaders"]
        ),
    ],
    targets: [
        .target(
            name: "MetalShaders"
        ),

    ]
)

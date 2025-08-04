// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SerenaApp",
    platforms: [
        .macOS(.v15), .iOS(.v26)
    ],
    products: [
        .library(
            name: "SerenaApp",
            targets: ["SerenaApp"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/sharing-grdb", from: "0.5.0"),
        .package(name: "KanjiVGParser", path: "./KanjiVGParser"),
//        .package(name: "MetalShaders", path: "./MetalShaders"),
    ],
    targets: [
        .target(
            name: "SerenaApp",
            dependencies: [
                .product(name: "SharingGRDB", package: "sharing-grdb"),
                "KanjiVGParser",
//                "MetalShaders",
            ],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)

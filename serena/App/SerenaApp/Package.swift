// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "SerenaApp",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v15), .iOS(.v18),
    ],
    products: [
        .library(
            name: "SerenaApp",
            targets: ["SerenaApp"],
        ),
    ],
    dependencies: [
        .package(name: "KanjiVGParser", path: "../KanjiVGParser"),
        .package(name: "Training", path: "../Training"),
        .package(name: "Navigation", path: "../Navigation"),
        .package(name: "DesignSystem", path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "SerenaApp",
            dependencies: [
                "KanjiVGParser",
                "DesignSystem",
                "Navigation",
                "Training",
            ],
            resources: [
                .process("Resources"),
            ],
        ),
    ],
)

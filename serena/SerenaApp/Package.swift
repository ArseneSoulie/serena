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
        .package(url: "https://github.com/pointfreeco/sharing-grdb", from: "0.5.0"),
        .package(name: "KanjiVGParser", path: "./KanjiVGParser"),
        .package(name: "Kana", path: "./Kana"),
        .package(name: "Navigation", path: "./Navigation"),
        .package(name: "DesignSystem", path: "./DesignSystem"),
    ],
    targets: [
        .target(
            name: "SerenaApp",
            dependencies: [
                .product(name: "SharingGRDB", package: "sharing-grdb"),
                "KanjiVGParser",
                "DesignSystem",
                "Navigation",
                "Kana",
            ],
            resources: [
                .process("Resources"),
            ],
        ),
    ],
)

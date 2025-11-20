// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "ReinaApp",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v15), .iOS(.v18),
    ],
    products: [
        .library(
            name: "ReinaApp",
            targets: ["ReinaApp"],
        ),
    ],
    dependencies: [
        .package(name: "About", path: "../About"),
        .package(name: "Mnemonics", path: "../Mnemonics"),
        .package(name: "Typist", path: "../Typist"),
        .package(name: "Training", path: "../Training"),
        .package(name: "Learn", path: "../Learn"),
        .package(name: "Navigation", path: "../Navigation"),
    ],
    targets: [
        .target(
            name: "ReinaApp",
            dependencies: [
                "About",
                "Mnemonics",
                "Learn",
                "Typist",
                "Navigation",
                "Training",
            ],
            resources: [
                .process("Resources"),
            ],
        ),
    ],
)

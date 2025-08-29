// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FontManager",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "FontManager",
            targets: ["FontManager"]),
    ],
    dependencies: [
        .package(url: "https://github.com/resoul/AtomicKit.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "FontManager",
            dependencies: ["AtomicKit"],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
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
    targets: [
        .target(
            name: "FontManager",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
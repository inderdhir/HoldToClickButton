// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "HoldToClickButton",
    platforms: [.iOS(.v14), .macOS(.v13), .watchOS(.v7)],
    products: [
        .library(
            name: "HoldToClickButton",
            targets: ["HoldToClickButton"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HoldToClickButton",
            dependencies: []),
        .testTarget(
            name: "HoldToClickButtonTests",
            dependencies: ["HoldToClickButton"]),
    ]
)

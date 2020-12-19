// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HoldToClickButton",
    platforms: [.iOS(.v11)],
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

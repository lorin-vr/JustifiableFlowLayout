// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JustifiableFlowLayout",
    platforms: [
           .iOS(.v16),
           .macOS(.v13)
    ],
    products: [
        .library(
            name: "JustifiableFlowLayout",
            targets: ["JustifiableFlowLayout"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "JustifiableFlowLayout",
            dependencies: [])
    ]
)

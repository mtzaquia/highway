// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Highway",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Highway",
            targets: ["Highway"]),
    ],
    targets: [
        .target(
            name: "Highway",
            dependencies: []),
        .testTarget(
            name: "HighwayTests",
            dependencies: ["Highway"]),
    ]
)

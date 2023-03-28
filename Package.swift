// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "RotatingLabel",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "RotatingLabel",
            targets: ["RotatingLabel"]
        )
    ],
    targets: [
        .target(
            name: "RotatingLabel",
            path: "RotatingLabel"
        )
    ]
)

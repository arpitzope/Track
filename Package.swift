// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Burnrate",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Burnrate",
            targets: ["Burnrate"])
    ],
    targets: [
        .target(
            name: "Burnrate",
            dependencies: [],
            path: "Sources")
    ]
)

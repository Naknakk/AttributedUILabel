// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FigmaUILabel",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "FigmaUILabel", targets: ["FigmaUILabel"])
    ],
    targets: [
        .target(
            name: "FigmaUILabel",
            path: "Sources/FigmaUILabel"
        ),
        .testTarget(
            name: "FigmaUILabelTests",
            dependencies: ["FigmaUILabel"],
            path: "Tests/FigmaUILabelTests"
        )
    ]
)

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CoreNavigation",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CoreNavigation", targets: ["CoreNavigation"]),
    ],
    targets: [
        .target(name: "CoreNavigation", path: "Sources"),
    ]
)

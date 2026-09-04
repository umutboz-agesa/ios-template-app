// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
    ],
    dependencies: [
        // Coil karşılığı — SabancimAsyncImage (LazyImage) bunu kullanır.
        .package(url: "https://github.com/kean/Nuke", from: "12.0.0"),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "NukeUI", package: "Nuke"),
            ],
            path: "Sources",
            resources: [.process("Resources")]
        ),
    ]
)

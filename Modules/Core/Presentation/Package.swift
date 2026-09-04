// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CorePresentation",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CorePresentation", targets: ["CorePresentation"]),
    ],
    dependencies: [
        .package(path: "../../DesignSystem"),
        .package(path: "../Common"),
    ],
    targets: [
        .target(
            name: "CorePresentation",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "CoreCommon", package: "Common"),
            ],
            path: "Sources"
        ),
    ]
)

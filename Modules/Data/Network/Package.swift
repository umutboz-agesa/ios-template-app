// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DataNetwork",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DataNetwork", targets: ["DataNetwork"]),
    ],
    dependencies: [
        .package(path: "../../Core/Common"),
        // İzinli cross-layer: Data → session sözleşmesi (AuthInterceptor/HTTPClient
        // SessionManaging'i okur). Tam Domain/Identity artık SPM değil (App
        // target'ının düz kaynağı) — bu yüzden sadece sözleşmeyi taşıyan
        // küçük CoreSession paketine bağımlı.
        .package(path: "../../Core/Session"),
    ],
    targets: [
        .target(
            name: "DataNetwork",
            dependencies: [
                .product(name: "CoreCommon", package: "Common"),
                .product(name: "CoreSession", package: "Session"),
            ],
            path: "Sources"
        ),
    ]
)

// swift-tools-version: 6.0
import PackageDescription

// SessionManaging + SessionManager bilerek burada, Domain/Identity'nin geri
// kalanından AYRI: DataNetwork (AuthInterceptor/HTTPClient) bu sözleşmeye
// ihtiyaç duyuyor ve DataNetwork bir SPM paketi olarak kaldı — ama Domain/Identity
// artık SPM DEĞİL (App target'ının düz kaynak ağacı). SPM bir target, App
// target'ının düz .swift dosyalarını import edemez; bu yüzden sadece bu
// protokol/actor çifti burada, küçük ve bağımsız bir pakette yaşıyor.
let package = Package(
    name: "CoreSession",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CoreSession", targets: ["CoreSession"]),
    ],
    targets: [
        .target(name: "CoreSession", path: "Sources"),
    ]
)

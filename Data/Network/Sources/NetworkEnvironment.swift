import Foundation

/// Android **product flavor** sisteminin karşılığı (preprod / tst / prd / pilot / mock).
///
/// Android'de bu, `build-logic/.../SabancimFlavors.kt` + BuildConfig field'larıyla
/// derleme zamanında geliyordu. iOS'ta karşılığı **Xcode scheme + .xcconfig** ile
/// üretilen `Info.plist` değerleri; burada tip-güvenli enum olarak modellenir.
/// Tuist tarafında her flavor bir `scheme` + `configuration` olur.
public enum NetworkEnvironment: String, Sendable, CaseIterable {
    case preprod
    case tst
    case prd
    case pilot
    case mock

    /// Backend adresi artık **Config/<Flavor>.xcconfig**'teki `API_BASE_URL`'den
    /// gelir (Info.plist'e `ApiBaseURL` anahtarıyla enjekte edilir) — Swift
    /// tarafında hardcoded switch YOK. Mock flavor'da xcconfig'te bilerek boş
    /// bırakıldığı için burada `nil` döner (ağ çağrısı yapılmaz).
    public var baseURL: URL? {
        guard
            let raw = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String,
            !raw.isEmpty
        else { return nil }
        return URL(string: raw)
    }

    public var hostName: String {
        baseURL?.host() ?? ""
    }

    /// Aktif flavor — Tuist scheme/xcconfig ile app Info.plist'e yazılan
    /// `SabancimFlavor` anahtarından okunur (DEĞER katmanı → tip-güvenli enum köprüsü).
    /// Android `BuildConfig.FLAVOR` okuma karşılığı. Anahtar yoksa (ör. saf test
    /// bundle) güvenli varsayılana düşer.
    public static var current: NetworkEnvironment {
        guard
            let raw = Bundle.main.object(forInfoDictionaryKey: "SabancimFlavor") as? String,
            let env = NetworkEnvironment(rawValue: raw)
        else {
            #if DEBUG
            return .tst
            #else
            return .prd
            #endif
        }
        return env
    }

    public var isMock: Bool { self == .mock }
    public var isProd: Bool { self == .prd || self == .pilot }
    public var isInternalCertificate: Bool { self == .tst }

    /// Cert pinning SHA anahtarları (Android `local.properties` `agesa.shaKeyN.<flavor>`
    /// karşılığı). Üretimde .xcconfig / Keychain'den enjekte edilir. Boşsa pinning skip.
    public var pinnedSHAKeys: [String] { [] }
}

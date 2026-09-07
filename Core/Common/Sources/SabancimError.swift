import Foundation

/// Android `:data` içindeki `SabancimError` sealed hierarchy'sinin karşılığı.
///
/// > Not: Android'de bu tip `:data` modülünde yaşıyordu; iOS'ta domain katmanı
/// > `:data`'yı göremediği için (bağımlılık yönü) hata tipini `CoreCommon`'a
/// > taşıdık. Böylece hem `Domain*` hem `Data` aynı `SabancimError`'ı kullanır,
/// > `any Error` existential'ı yerine `Sendable` somut tip elde ederiz.
public enum SabancimError: Error, Equatable, Sendable {
    /// 401 / 403 → Session expired → Login'e dön
    case auth
    /// 404 → "İçerik bulunamadı"
    case notFound
    /// 422 → field bazlı doğrulama hataları
    case validation([ValidationItem])
    /// 5xx → "Servis hatası"
    case network(code: Int)
    /// errorCode == "warning_token_expire" → token refresh / re-login
    case tokenExpired
    /// URLError (offline) → "Bağlantı yok"
    case reachability
    /// TLS / cert hatası → "Güvenli bağlantı kurulamadı"
    case ssl
    /// Diğer her şey
    case unknown(message: String)

    public var userMessage: String {
        switch self {
        case .auth: "Oturum süresi doldu. Lütfen tekrar giriş yapın."
        case .notFound: "İçerik bulunamadı."
        case .validation(let items): items.first?.message ?? "Doğrulama hatası."
        case .network: "Servis hatası. Lütfen daha sonra tekrar deneyin."
        case .tokenExpired: "Oturumunuz yenileniyor."
        case .reachability: "İnternet bağlantısı yok."
        case .ssl: "Güvenli bağlantı kurulamadı."
        case .unknown(let message): message
        }
    }
}

/// 422 doğrulama yanıtındaki tek bir alan hatası (`validations[]`).
public struct ValidationItem: Equatable, Sendable {
    public let field: String
    public let message: String
    public init(field: String, message: String) {
        self.field = field
        self.message = message
    }
}

import Foundation

/// Android `:domain:identity` `SessionManager` contract'ı karşılığı.
///
/// Bu protokol `DomainIdentity`'de yaşar; `Data` katmanı (AuthInterceptor + HTTPClient)
/// **sadece bu sözleşmeyi** görür — izinli cross-layer bağımlılık. Tersi yasaktır.
public protocol SessionManaging: Sendable {
    var sessionCookie: String? { get async }
    var isAuthenticated: Bool { get async }
    func updateSessionCookie(_ cookie: String?) async
    func clear() async
}

/// Varsayılan in-memory implementasyon (actor → thread-safe, Android `SessionManager` paraleli).
/// Üretimde cookie Keychain'e yazılır (`:core:security` SecureStorage).
public actor SessionManager: SessionManaging {
    private var cookie: String?

    public init(cookie: String? = nil) { self.cookie = cookie }

    public var sessionCookie: String? { cookie }
    public var isAuthenticated: Bool { cookie != nil }

    public func updateSessionCookie(_ cookie: String?) { self.cookie = cookie }
    public func clear() { cookie = nil }
}

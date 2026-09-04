import Foundation
import Observation
import Dependencies

/// UI için türetilmiş kullanıcı görüntü modeli (isim vb.).
public struct UserProfile: Equatable, Sendable {
    /// Selamlama/rozet için ad
    public let firstName: String
    /// Tam ad
    public let fullName: String

    public init(firstName: String, fullName: String) {
        self.firstName = firstName
        self.fullName = fullName
    }
}

/// Oturum + geçerli kullanıcı — uygulama genelinde **TEK kaynak**.
///
/// Login / OTP başarısında `signIn(_:)` ile `AuthenticationResult` buraya yazılır
/// (yazan yer artık use-case'ler); tüm ekranlar `@Dependency(\.userSession)` üzerinden
/// okur (isim, profil, oturum var mı). `@Observable` + `@MainActor` olduğu için değer
/// değişince bağlı UI otomatik güncellenir ve reference-type olarak her yerde aynı örnek
/// paylaşılır (singleton — swift-dependencies).
///
/// Kalıcılık (uygulama kapanınca da kalsın): token Keychain'e (`SessionManager`/SecureStorage),
/// istenirse profil UserDefaults/Keychain'e yazılır ve açılışta `signIn` ile geri yüklenir.
@MainActor
@Observable
public final class UserSession {
    /// Login/OTP'den dönen ham sonuç — tek gerçek kaynak.
    public private(set) var authentication: AuthenticationResult? = nil

    /// Oturum yokken (login öncesi / mock-dev) gösterilecek varsayılan profil.
    private let fallbackProfile: UserProfile

    nonisolated public init(
        fallbackProfile: UserProfile = UserProfile(firstName: "Misafir", fullName: "Misafir")
    ) {
        self.fallbackProfile = fallbackProfile
    }

    public var user: AuthenticatedUser? { authentication?.user }
    public var isSignedIn: Bool { authentication != nil }

    /// UI profili — oturum varsa gerçek kullanıcı, yoksa fallback.
    public var profile: UserProfile {
        guard let user = authentication?.user,
              !user.fullName.trimmingCharacters(in: .whitespaces).isEmpty
        else { return fallbackProfile }
        let first = user.fullName.split(separator: " ").first.map(String.init) ?? user.fullName
        return UserProfile(firstName: first, fullName: user.fullName)
    }

    // MARK: - Mutasyon (yalnızca auth akışı yazar)
    public func signIn(_ result: AuthenticationResult) {
        authentication = result
    }

    public func signOut() {
        authentication = nil
    }
}

private enum UserSessionKey: DependencyKey {
    /// Tek paylaşılan örnek. Mock/dev'de oturum yokken fallback isim
    static let liveValue = UserSession(
        fallbackProfile: UserProfile(firstName: "Misafir", fullName: "Misafir")
    )
    static let testValue = UserSession(
        fallbackProfile: UserProfile(firstName: "Test", fullName: "Test Kullanıcı")
    )
}

public extension DependencyValues {
    /// Uygulamanın oturum/kullanıcı deposu (tek kaynak).
    var userSession: UserSession {
        get { self[UserSessionKey.self] }
        set { self[UserSessionKey.self] = newValue }
    }
}

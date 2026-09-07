import Foundation

/// Android `:domain:identity` `LoginUseCase` karşılığı.
/// Not: `username` validation'ı kaldırıldı — `LoginCredentials`'ta artık yok.
///
/// Başarılı girişte dönen `AuthenticationResult` uygulama oturumuna (`UserSession`)
/// BURADA yazılır — böylece login'i tetikleyen HER yol (normal login, ileride
/// biyometrik/otomatik login) oturumu tek noktadan kurar; ViewModel'ler tekrar etmez.
public struct LoginUseCase: Sendable {
    private let repository: any AuthRepository
    private let session: UserSession

    public init(repository: any AuthRepository, session: UserSession) {
        self.repository = repository
        self.session = session
    }

    public func callAsFunction(_ credentials: LoginCredentials) async -> SabancimResult<AuthenticationResult> {
        guard credentials.password.count >= 6 else {
            return .failure(.validation([
                ValidationItem(field: "password", message: "Şifre en az 6 karakter olmalı.")
            ]))
        }
        let result = await repository.login(credentials)
        if case let .success(authentication) = result {
            await session.signIn(authentication)   // @MainActor'a hop — tek kaynak güncellenir
        }
        return result
    }
}

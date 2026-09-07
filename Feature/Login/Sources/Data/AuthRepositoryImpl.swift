import Foundation

/// Not: `login`'de token/session'ı elle yazmaya gerek yok — `Set-Cookie` header'ı
/// HTTPClient'ın interceptor zincirinde otomatik yakalanıyor (bkz. OtpConfirmation
/// konuşmasındaki aynı bulgu). `session` sadece `logout()` için tutuluyor.
final class AuthRepositoryImpl: AuthRepository, @unchecked Sendable {
    private let remote: AuthRemoteDataSource
    private let session: any SessionManaging

    init(remote: AuthRemoteDataSource, session: any SessionManaging) {
        self.remote = remote
        self.session = session
    }

    func login(_ credentials: LoginCredentials) async -> SabancimResult<AuthenticationResult> {
        await remote.login(credentials)
    }

    func logout() async {
        await session.clear()
    }
}

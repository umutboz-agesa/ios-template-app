import Foundation
 
final class AuthRemoteDataSource: BaseRemoteDataSource, @unchecked Sendable {
    private let api: AuthApi
    init(api: AuthApi) { self.api = api }
 
    func login(_ credentials: LoginCredentials) async -> AppResult<AuthenticationResult> {
        await apiCall {
            let request = LoginRequestDTO(password: credentials.password, uuid: credentials.deviceUUID)
            let response = try await api.login(request)
            guard response.success, let customData = response.customData else {
                throw AppError.unknown(message: response.message ?? response.error ?? "Giriş başarısız.")
            }
            return customData.toDomain()
        }
    }
}

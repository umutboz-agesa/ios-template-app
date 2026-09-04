import Foundation
import DataNetwork
import CoreCommon
 
final class AuthRemoteDataSource: BaseRemoteDataSource, @unchecked Sendable {
    private let api: AuthApi
    init(api: AuthApi) { self.api = api }
 
    func login(_ credentials: LoginCredentials) async -> SabancimResult<AuthenticationResult> {
        await apiCall {
            let request = LoginRequestDTO(password: credentials.password, uuid: credentials.deviceUUID)
            let response = try await api.login(request)
            guard response.success, let customData = response.customData else {
                throw SabancimError.unknown(message: response.message ?? response.error ?? "Giriş başarısız.")
            }
            return customData.toDomain()
        }
    }
}

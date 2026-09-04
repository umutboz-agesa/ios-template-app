import Foundation
import DataNetwork
 
/// Not: `APIEnvelope<T>` DEĞİL — düz şema (`loginRegistration`/`otpConfirmation` gibi).
struct AuthApi: Sendable {
    let client: HTTPClient
 
    func login(_ request: LoginRequestDTO) async throws -> LoginResponseDTO {
        try await client.request(
            Endpoints.Login.login,
            method: .post,
            body: request,
            as: LoginResponseDTO.self
        )
    }
}

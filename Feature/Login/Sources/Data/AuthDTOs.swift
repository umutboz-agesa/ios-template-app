import Foundation
 
/// Gerçek `LoginParameter`'a göre — POC'taki (username/password) DEĞİL.
struct LoginRequestDTO: Encodable, Sendable {
    let password: String
    let uuid: String
}
 
/// Gerçek response'a göre — `loginRegistration`/`otpConfirmation` ile aynı düz şema.
struct LoginResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String?
    let error: String?
    let customData: AuthenticationCustomDataDTO?
}

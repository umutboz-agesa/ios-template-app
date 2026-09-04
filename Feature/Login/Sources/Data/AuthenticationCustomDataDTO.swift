//
//  AuthenticationCustomDataDTO.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation
 
/// Login ve OTP confirmation response'ları `customData`/`user` altında BİREBİR aynı
/// şemayı paylaşıyor — tek fark `needDisclaimer`'ın OTP confirmation'da hiç
/// gelmemesi, bu yüzden optional.
struct AuthenticationCustomDataDTO: Decodable, Sendable {
    let needChangePassword: Bool
    let needDisclaimer: Bool?
    let lastLoggedInTime: String
    let lastWrongLoginTime: String
    let user: AuthenticationUserDTO
}
 
struct AuthenticationUserDTO: Decodable, Sendable {
    let name: String
    let surname: String
    let customerNumber: Int
    let userAnalyticId: String
    let birthdate: String
    let email: String?
    let phone: String?
    let identityNumber: String?
    

    private enum CodingKeys: String, CodingKey {
        case name, surname, customerNumber, userAnalyticId, email, phone, identityNumber,birthdate
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        surname = try c.decode(String.self, forKey: .surname)
        customerNumber = try c.decode(Int.self, forKey: .customerNumber)
        userAnalyticId = try c.decode(String.self, forKey: .userAnalyticId)
        birthdate = try c.decode(String.self, forKey: .birthdate)
        email = try? c.decode(String.self, forKey: .email)
        phone = AuthenticationUserDTO.decodeFlexibleString(c, .phone)
        identityNumber = AuthenticationUserDTO.decodeFlexibleString(c, .identityNumber)
    }

    /// String ya da sayısal gelebilecek alanı güvenle String'e çevirir; yoksa nil.
    private static func decodeFlexibleString(
        _ c: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys
    ) -> String? {
        if let s = try? c.decode(String.self, forKey: key) { return s }
        if let n = try? c.decode(Int.self, forKey: key) { return String(n) }
        return nil
    }
}
 
extension AuthenticationCustomDataDTO {
    func toDomain() -> AuthenticationResult {
        AuthenticationResult(
            user: AuthenticatedUser(
                customerNumber: user.customerNumber,
                name: user.name,
                surname: user.surname,
                userAnalyticId: user.userAnalyticId,
                birthdate : user.birthdate,
                email: user.email,
                phone: user.phone,
                identityNumber: user.identityNumber
              
            ),
            userAnalyticId: user.userAnalyticId,
            needsPasswordChange: needChangePassword,
            needsDisclaimer: needDisclaimer ?? false,
            lastLoggedInTime: lastLoggedInTime,
            lastWrongLoginTime: lastWrongLoginTime
        )
    }
}

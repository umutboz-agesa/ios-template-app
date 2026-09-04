//
//  AuthenticationResult.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation

/// Login ve OTP confirmation aynı şeklide sonuç dönüyor — bu yüzden tek, paylaşılan
/// bir domain tipi. `needsDisclaimer` OTP confirmation'ın gerçek response'unda YOKTU,
/// login'de var — DTO tarafında optional olarak ele alınıp burada `Bool` olarak
/// (yoksa `false`) normalize ediliyor.
public struct AuthenticationResult: Sendable, Equatable {
    public let user: AuthenticatedUser
    /// Eski VIPER'daki `AnalyticsEventHelper.setUserID(for:)`'a geçirilen alan.
    public let userAnalyticId: String
    public let needsPasswordChange: Bool
    public let needsDisclaimer: Bool
    public let lastLoggedInTime: String
    public let lastWrongLoginTime: String

    public init(
        user: AuthenticatedUser,
        userAnalyticId: String,
        needsPasswordChange: Bool,
        needsDisclaimer: Bool,
        lastLoggedInTime: String,
        lastWrongLoginTime: String
    ) {
        self.user = user
        self.userAnalyticId = userAnalyticId
        self.needsPasswordChange = needsPasswordChange
        self.needsDisclaimer = needsDisclaimer
        self.lastLoggedInTime = lastLoggedInTime
        self.lastWrongLoginTime = lastWrongLoginTime
    }
}

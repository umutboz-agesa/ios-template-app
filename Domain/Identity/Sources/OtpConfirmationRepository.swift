//
//  OtpConfirmationRepository.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation

public struct OtpConfirmationRequest: Sendable, Equatable {
    public let confirmationCode: String
    public let deviceUUID: String
    public let pushToken: String?

    public init(confirmationCode: String, deviceUUID: String, pushToken: String? = nil) {
        self.confirmationCode = confirmationCode
        self.deviceUUID = deviceUUID
        self.pushToken = pushToken
    }
}

/// Not: dönüş tipi artık `OtpConfirmationResult` DEĞİL, paylaşılan `AuthenticationResult`
/// (login ile aynı şekilde sonuç dönüyorlar) — bkz. AuthenticationResult.swift.
public protocol OtpConfirmationRepository: Sendable {
    func confirmOtp(_ request: OtpConfirmationRequest) async -> SabancimResult<AuthenticationResult>
}

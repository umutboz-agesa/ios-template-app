//
//  OtpConfirmationRepositoryImpl.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation

final class OtpConfirmationRepositoryImpl: OtpConfirmationRepository, @unchecked Sendable {
    /// TODO: gerçek değeri/anlamı netleşince adlandırılmış bir sabite/enum'a çevir.
    private static let loginConfirmationSource: Int8 = 1

    private let remote: OtpConfirmationRemoteDataSource

    init(remote: OtpConfirmationRemoteDataSource) {
        self.remote = remote
    }

    func confirmOtp(_ request: OtpConfirmationRequest) async -> SabancimResult<AuthenticationResult> {
        let dto = OtpConfirmationRequestDTO(
            uuid: request.deviceUUID,
            confirmationCode: request.confirmationCode,
            source: Self.loginConfirmationSource,
            pushToken: request.pushToken ?? ""
        )
        return await remote.confirmOtp(dto)
    }
}

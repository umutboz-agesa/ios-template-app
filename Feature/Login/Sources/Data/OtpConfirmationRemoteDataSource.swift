//
//  OtpConfirmationRemoteDataSource.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation

final class OtpConfirmationRemoteDataSource: BaseRemoteDataSource, @unchecked Sendable {
    private let api: OtpConfirmationApi
    init(api: OtpConfirmationApi) { self.api = api }

    func confirmOtp(_ request: OtpConfirmationRequestDTO) async -> SabancimResult<AuthenticationResult> {
        await apiCall {
            let response = try await api.confirmOtp(request)
            guard response.success, let customData = response.customData else {
                throw SabancimError.unknown(message: response.message ?? response.error ?? "Doğrulama başarısız.")
            }
            return customData.toDomain()
        }
    }
}

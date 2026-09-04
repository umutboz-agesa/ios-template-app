//
//  OtpConfirmationApi.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation
import DataNetwork

/// Not: `APIEnvelope<T>` DEĞİL — bu endpoint `loginRegistration` gibi düz bir şema
/// döndürüyor (`success` doğrudan üst seviyede).
struct OtpConfirmationApi: Sendable {
    let client: HTTPClient

    func confirmOtp(_ request: OtpConfirmationRequestDTO) async throws -> OtpConfirmationResponseDTO {
        try await client.request(
            Endpoints.Login.otpConfirmation,
            method: .post,
            body: request,
            as: OtpConfirmationResponseDTO.self
        )
    }
}

//
//  ConfirmOtpUseCase.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation

/// Android `:domain:identity` `ConfirmOtpUseCase` karşılığı.
///
/// OTP onayı başarılıysa dönen `AuthenticationResult` oturuma (`UserSession`) BURADA
/// yazılır — login akışıyla aynı desen, tek kaynaktan.
public struct ConfirmOtpUseCase: Sendable {
    private let repository: any OtpConfirmationRepository
    private let session: UserSession

    public init(repository: any OtpConfirmationRepository, session: UserSession) {
        self.repository = repository
        self.session = session
    }

    public func callAsFunction(_ request: OtpConfirmationRequest) async -> SabancimResult<AuthenticationResult> {
        guard !request.confirmationCode.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .failure(.validation([
                ValidationItem(field: "confirmationCode", message: "Doğrulama kodu boş olamaz.")
            ]))
        }
        let result = await repository.confirmOtp(request)
        if case let .success(authentication) = result {
            await session.signIn(authentication)
        }
        return result
    }
}

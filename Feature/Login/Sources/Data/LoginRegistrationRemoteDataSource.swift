//
//  LoginRegistrationRemoteDataSource.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation
import DataNetwork
import CoreCommon
 
final class LoginRegistrationRemoteDataSource: BaseRemoteDataSource, @unchecked Sendable {
    private let api: LoginRegistrationApi
    init(api: LoginRegistrationApi) { self.api = api }
 
    func loginRegistration(_ request: LoginRegistrationRequestDTO) async -> SabancimResult<Void> {
        await apiCall {
            let response = try await api.loginRegistration(request)
            guard response.success else {
                throw SabancimError.unknown(message: response.message ?? response.error ?? "Giriş başarısız.")
            }
        }
    }
}

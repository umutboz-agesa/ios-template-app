//
//  LoginRegistrationUseCase.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation
 
/// Android `:domain:identity` `LoginRegistrationUseCase` karşılığı.
/// Validation + domain logic burada; UI'dan ayrık, test edilebilir.
public struct LoginRegistrationUseCase: Sendable {
    private let repository: any LoginRegistrationRepository
 
    public init(repository: any LoginRegistrationRepository) {
        self.repository = repository
    }
 
    public func callAsFunction(_ credentials: LoginRegistrationCredentials) async -> SabancimResult<Void> {
        guard !credentials.identityNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .failure(.validation([
                ValidationItem(field: "identityNumber", message: "TC kimlik numarası boş olamaz.")
            ]))
        }
        guard credentials.password.count >= 6 else {
            return .failure(.validation([
                ValidationItem(field: "password", message: "Şifre en az 6 karakter olmalı.")
            ]))
        }
        guard credentials.contractTextReaded else {
            return .failure(.validation([
                ValidationItem(field: "contractTextReaded", message: "Sözleşme metni onaylanmalı.")
            ]))
        }
        return await repository.loginRegistration(credentials)
    }
}

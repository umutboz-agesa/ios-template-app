//
//  LoginRegistrationApi.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation
 
/// Not: `APIEnvelope<T>` DEĞİL doğrudan `LoginRegistrationResponseDTO` — bu endpoint'in
/// kendi düz `success` alanı var, genel zarf şemasını kullanmıyor.
struct LoginRegistrationApi: Sendable {
    let client: HTTPClient
 
    func loginRegistration(_ request: LoginRegistrationRequestDTO) async throws -> LoginRegistrationResponseDTO {
        try await client.request(
            Endpoints.Login.registration,
            method: .post,
            body: request,
            as: LoginRegistrationResponseDTO.self
        )
    }
}

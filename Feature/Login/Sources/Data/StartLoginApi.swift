//
//  StartLoginApi.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 24.07.2026.
//
import Foundation
import DataNetwork
 
///`.startLogin` endpoint'i.
struct StartLoginApi: Sendable {
    let client: HTTPClient
 
    func startLogin(_ request: StartLoginRequestDTO) async throws -> APIEnvelope<StartLoginResponseDTO> {
        try await client.request(
            Endpoints.Login.startLogin,
            method: .post,
            body: request,
            as: APIEnvelope<StartLoginResponseDTO>.self
        )
    }
}

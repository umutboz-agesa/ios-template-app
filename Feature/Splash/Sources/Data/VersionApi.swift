//
//  VersionApi.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//
import Foundation

/// `AuthApi` kalıbı — HTTPClient üzerine tipli çağrı sarmalayıcısı.
struct VersionApi: Sendable {
    let client: HTTPClient

    func check(_ request: VersionRequestDTO) async throws -> APIEnvelope<VersionResponseDTO> {
        try await client.request(
            Endpoints.Login.versionCheck,
            method: .post,
            body: request,
            as: APIEnvelope<VersionResponseDTO>.self
        )
    }
}

//
//  PensionContractsAndSummaryApi.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 29.07.2026.
//
import Foundation

struct PensionContractsAndSummaryApi: Sendable {
    let client: HTTPClient

    func fetch() async throws -> APIEnvelope<PensionContractsAndSummaryDataDTO> {
        try await client.request(
            Endpoints.Customer.pensionContractsAndSummary,
            method: .get,
            as: APIEnvelope<PensionContractsAndSummaryDataDTO>.self
        )
    }
}

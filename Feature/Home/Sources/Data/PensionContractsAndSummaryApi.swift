//
//  PensionContractsAndSummaryApi.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 3.09.2026.
//
import Foundation
import DataNetwork

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

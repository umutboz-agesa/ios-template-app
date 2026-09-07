//
//  PensionContractsAndSummaryRemoteDataSource.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 29.07.2026.
//
import Foundation

final class PensionContractsAndSummaryRemoteDataSource: BaseRemoteDataSource, @unchecked Sendable {
    private let api: PensionContractsAndSummaryApi
    init(api: PensionContractsAndSummaryApi) { self.api = api }

    func fetchSummary() async -> SabancimResult<PensionContractsSummary> {
        await apiCall {
            try await api.fetch().unwrap().toDomain()
        }
    }
}

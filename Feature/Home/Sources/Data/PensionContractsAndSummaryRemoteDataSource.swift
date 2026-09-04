//
//  PensionContractsAndSummaryRemoteDataSource.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 3.09.2026.
//
import Foundation
import DataNetwork
import CoreCommon

final class PensionContractsAndSummaryRemoteDataSource: BaseRemoteDataSource, @unchecked Sendable {
    private let api: PensionContractsAndSummaryApi
    init(api: PensionContractsAndSummaryApi) { self.api = api }

    func fetchSummary() async -> SabancimResult<PensionContractsSummary> {
        await apiCall {
            try await api.fetch().unwrap().toDomain()
        }
    }
}

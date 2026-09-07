//
//  PensionContractsSummaryRepositoryImpl.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 29.07.2026.
//
import Foundation

final class PensionContractsSummaryRepositoryImpl: PensionContractsSummaryRepository, @unchecked Sendable {
    private let remote: PensionContractsAndSummaryRemoteDataSource

    init(remote: PensionContractsAndSummaryRemoteDataSource) {
        self.remote = remote
    }

    func fetchSummary() async -> SabancimResult<PensionContractsSummary> {
        await remote.fetchSummary()
    }
}

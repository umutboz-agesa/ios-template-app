//
//  DataPolicyModule.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 4.08.2026.
//
import Foundation

public enum DataPolicyModule {
    public static func makePensionContractsSummaryRepository(client: HTTPClient) -> any PensionContractsSummaryRepository {
        PensionContractsSummaryRepositoryImpl(
            remote: PensionContractsAndSummaryRemoteDataSource(api: PensionContractsAndSummaryApi(client: client))
        )
    }
}

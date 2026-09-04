//
//  DataPolicyModule.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 3.09.2026.
//
import Foundation
import DataNetwork

public enum DataPolicyModule {
    public static func makePensionContractsSummaryRepository(client: HTTPClient) -> any PensionContractsSummaryRepository {
        PensionContractsSummaryRepositoryImpl(
            remote: PensionContractsAndSummaryRemoteDataSource(api: PensionContractsAndSummaryApi(client: client))
        )
    }
}

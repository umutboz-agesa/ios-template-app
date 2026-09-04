//
//  StartLoginRemoteDataSource.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 24.07.2026.
//
import Foundation
import DataNetwork
import CoreCommon
 
final class StartLoginRemoteDataSource: BaseRemoteDataSource, @unchecked Sendable {
    private let api: StartLoginApi
    init(api: StartLoginApi) { self.api = api }
 
    func startLogin(_ request: StartLoginRequest) async -> SabancimResult<RecognizedUser?> {
        await apiCall {
            try await api
                .startLogin(StartLoginRequestDTO(
                    uuid: request.deviceUUID,
                    brand: "Apple",
                    osVersion: request.osVersion,
                    model: request.model,
                    appVersion: request.appVersion
                ))
                .unwrap()
                .toDomain()
        }
    }
}

//
//  StartLoginRepositoryImpl.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 24.07.2026.
//
import Foundation
import CoreCommon
 
final class StartLoginRepositoryImpl: StartLoginRepository, @unchecked Sendable {
    private let remote: StartLoginRemoteDataSource
 
    init(remote: StartLoginRemoteDataSource) {
        self.remote = remote
    }
 
    func startLogin(_ request: StartLoginRequest) async -> SabancimResult<RecognizedUser?> {
        await remote.startLogin(request)
    }
}

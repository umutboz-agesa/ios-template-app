//
//  VersionRemoteDataSource.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//
import Foundation
import DataNetwork
import CoreCommon

/// `AuthRemoteDataSource` kalıbı — `BaseRemoteDataSource.apiCall { }`.
/// VersionCheckInput → DTO → unwrap → toDomain(AppVersionInfo).
final class VersionRemoteDataSource: BaseRemoteDataSource, @unchecked Sendable {
    private let api: VersionApi
    init(api: VersionApi) { self.api = api }

    func check(_ input: VersionCheckInput) async -> SabancimResult<AppVersionInfo> {
        await apiCall {
            try await api
                .check(VersionRequestDTO(
                    operatingSystem: input.operatingSystem,
                    applicationVersion: input.applicationVersion,
                    genericContentVersion: input.genericContentVersion,
                    uuid: input.uuid
                ))
                .unwrap()          // APIEnvelope<T> → T (success=false ise throw)
                .toDomain()        // DTO → AppVersionInfo
        }
    }
}

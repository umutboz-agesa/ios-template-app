//
//  VersionRepositoryImpl.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//
import Foundation
import CoreCommon

/// `AuthRepositoryImpl` kalıbı — domain contract'ını implemente eder.
/// Ham `AppVersionInfo` döner; karar `CheckVersionUseCase`'te.
final class VersionRepositoryImpl: VersionRepository, @unchecked Sendable {
    private let remote: VersionRemoteDataSource
    init(remote: VersionRemoteDataSource) { self.remote = remote }

    func check(_ input: VersionCheckInput) async -> SabancimResult<AppVersionInfo> {
        await remote.check(input)
    }
}

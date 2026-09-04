//
//  VersionMapper.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//
import Foundation

/// DTO → Domain (`AppVersionInfo`). SADECE alan eşlemesi — KARAR YOK (o UseCase'te).
extension VersionResponseDTO {
    func toDomain() -> AppVersionInfo {
        AppVersionInfo(
            latestVersion: latestVersion,
            minSupportedVersion: minSupportedVersion,
            forceUpdate: forceUpdate,
            storeURL: storeUrl.flatMap { URL(string: $0) } ?? Self.fallbackStoreURL,
            message: message
        )
    }

    private static let fallbackStoreURL = URL(string: "https://apps.apple.com/app/agesa")!
}

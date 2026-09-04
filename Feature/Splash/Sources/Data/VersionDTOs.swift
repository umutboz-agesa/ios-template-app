//
//  VersionDTOs.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//
import Foundation

/// Android `versioncheck` request/response DTO'ları.
/// İstek alan adları backend sözleşmesi (CheckVersionParameters):
/// operatingSystem / applicationVersion / genericContentVersion / uuid.
struct VersionRequestDTO: Encodable, Sendable {
    let operatingSystem: Int
    let applicationVersion: String
    let genericContentVersion: Int
    let uuid: String
}

/// Backend yanıtı — ham sürüm bilgisi (karar App'te değil, UseCase'te verilir).
struct VersionResponseDTO: Decodable, Sendable {
    let latestVersion: String
    let minSupportedVersion: String
    let forceUpdate: Bool
    let storeUrl: String?
    let message: String?
}

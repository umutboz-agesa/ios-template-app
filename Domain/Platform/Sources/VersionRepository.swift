//
//  VersionRepository.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//

import Foundation

/// Android `:domain:platform` `VersionRepository` contract'ı karşılığı.
/// Implementasyon `Feature:Splash` içinde (`VersionRepositoryImpl`),
/// swift-dependencies ile bağlanır (Android `@Binds`).
public protocol VersionRepository: Sendable {
    func check(_ input: VersionCheckInput) async -> SabancimResult<AppVersionInfo>
}

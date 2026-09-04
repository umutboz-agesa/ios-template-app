//
//  PlatformDependencies.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//
import Foundation
import Dependencies
import CoreCommon

/// versionRepository DI anahtarı.
/// `DependencyKey` (liveValue VAR) — çünkü version check'in makul canlı varsayılanı
/// var: bağlanmazsa (mock flavor) toleranslı `.upToDate`. Böylece "no live
/// implementation ... accessed from a live context" uyarısı çıkmaz.
/// TST/PRD'de `AppComposition` bunu gerçek repo ile override eder.
///
public enum VersionRepositoryKey: DependencyKey {
    public static let liveValue: any VersionRepository = DefaultVersionRepository()
}


public extension DependencyValues {
    var versionRepository: any VersionRepository {
        get { self[VersionRepositoryKey.self] }
        set { self[VersionRepositoryKey.self] = newValue }
    }
}


/// Toleranslı varsayılan — bağlanmazsa açılışı bloklama: her zaman "güncel" ham bilgi.
/// (Eski ad `UnimplementedVersionRepository`; artık gerçek bir liveValue olduğu için
/// `DefaultVersionRepository` daha doğru.)
struct DefaultVersionRepository: VersionRepository {
    func check(_ input: VersionCheckInput) async -> SabancimResult<AppVersionInfo> {
        .success(AppVersionInfo(
            latestVersion: input.applicationVersion,
            minSupportedVersion: "0.0.0",
            forceUpdate: false,
            storeURL: URL(string: "https://apps.apple.com")!,
            message: nil
        ))
    }
}

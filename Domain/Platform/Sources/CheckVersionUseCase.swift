//
//  Untitled.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//
import Foundation

/// Android `CheckVersionUseCase` karşılığı — business burada, UI/Data'dan ayrık.
/// Ham `AppVersionInfo` + `currentVersion` → `VersionCheckResult` kararı.
public struct CheckVersionUseCase: Sendable {
    private let repository: any VersionRepository

    public init(repository: any VersionRepository) {
        self.repository = repository
    }

    public func callAsFunction(_ input: VersionCheckInput) async -> SabancimResult<VersionCheckResult> {
        // Önce ham sonucu al — tipi net olsun (SabancimResult<AppVersionInfo>).
        let raw = await repository.check(input)
        // Sonra kararı ver: AppVersionInfo -> VersionCheckResult.
        return raw.map { info in
            decide(current: input.applicationVersion, info: info)
        }
    }

    /// Saf karar kuralı — testin doğrudan çağırabilmesi için internal & senkron.
    func decide(current: String, info: AppVersionInfo) -> VersionCheckResult {
        // 1) Zorunlu: backend flag'i VEYA min desteklenen sürümün altındaysa
        if info.forceUpdate || isOlder(current, than: info.minSupportedVersion) {
            return .forceUpdate(
                storeURL: info.storeURL,
                message: info.message ?? "Devam etmek için uygulamayı güncelleyin."
            )
        }
        // 2) Opsiyonel: en güncel sürümün altındaysa
        if isOlder(current, than: info.latestVersion) {
            return .softUpdate(storeURL: info.storeURL)
        }
        // 3) Güncel
        return .upToDate
    }

    /// "3.4.1" < "3.5.0" gibi semantik sürüm karşılaştırması (saf, test edilebilir).
    func isOlder(_ a: String, than b: String) -> Bool {
        let lhs = a.split(separator: ".").map { Int($0) ?? 0 }
        let rhs = b.split(separator: ".").map { Int($0) ?? 0 }
        for i in 0..<max(lhs.count, rhs.count) {
            let l = i < lhs.count ? lhs[i] : 0
            let r = i < rhs.count ? rhs[i] : 0
            if l != r { return l < r }
        }
        return false
    }
}

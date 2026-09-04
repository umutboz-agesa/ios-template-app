//
//  PlatformModels.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//

import Foundation

/// `:domain:platform` — Splash sürüm kontrolü saf domain modelleri.
/// Sürüm kontrolü girdisi — App'ten (Bundle) toplanıp use-case'e verilir.
public struct VersionCheckInput: Equatable, Sendable {
    public let applicationVersion: String   // applicationVersion — CFBundleShortVersionString
    public let operatingSystem: Int      // Android os int'i (ör. iOS için sabit)
    public let genericContentVersion: Int
    public let uuid: String

    public init(
        applicationVersion: String,
        operatingSystem: Int,
        genericContentVersion: Int = 0,
        uuid: String
    ) {
        self.applicationVersion = applicationVersion
        self.operatingSystem = operatingSystem
        self.genericContentVersion = genericContentVersion
        self.uuid = uuid
    }
}

/// Ham sunucu bilgisi — repository bunu döner, KARAR VERMEZ.
/// Android `AppVersionInfo` karşılığı.
public struct AppVersionInfo: Equatable, Sendable {
    public let latestVersion: String        // mağazadaki en güncel sürüm
    public let minSupportedVersion: String  // altında zorunlu güncelleme
    public let forceUpdate: Bool            // backend'in açık zorlama flag'i
    public let storeURL: URL
    public let message: String?

    public init(
        latestVersion: String,
        minSupportedVersion: String,
        forceUpdate: Bool,
        storeURL: URL,
        message: String?
    ) {
        self.latestVersion = latestVersion
        self.minSupportedVersion = minSupportedVersion
        self.forceUpdate = forceUpdate
        self.storeURL = storeURL
        self.message = message
    }
}



/// Sürüm kontrolü sonucu — backend flag'lerinin domain karşılığı.
public enum VersionCheckResult: Equatable, Sendable {
    /// Güncel — açılışa devam.
    case upToDate
    /// Opsiyonel güncelleme — uyar, "Sonra" ile devam.
    case softUpdate(storeURL: URL)
    /// Zorunlu güncelleme — bloklayan ekran, ilerleme yok.
    case forceUpdate(storeURL: URL, message: String)
}

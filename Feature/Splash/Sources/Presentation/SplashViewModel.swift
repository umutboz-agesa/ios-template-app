//
//  SplashViewModel.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//

import Foundation
import CoreSession
import Observation
import Dependencies
import CoreNavigation
import CoreCommon
import DataNetwork
import UIKit   // UIDevice.identifierForVendor

/// Splash ekranının UI-state'i. `Loadable` yerine kendi enum'u —
/// force/soft update özel UI gerektirdiği için.
public enum SplashState: Equatable, Sendable {
    case checking
    case softUpdate(storeURL: URL)
    case forceUpdate(storeURL: URL, message: String)
    case finished
}

/// Android `SplashViewModel` karşılığı. `LoginViewModel` kalıbı:
/// @Observable + @Dependency. İki iş: (a) sürüm kontrolü, (b) açılış yönlendirmesi.
@MainActor
@Observable
public final class SplashViewModel {
    public private(set) var state: SplashState = .checking

    @ObservationIgnored @Dependency(\.versionRepository) private var repository
    @ObservationIgnored @Dependency(\.sessionManager) private var session
    @ObservationIgnored @Dependency(\.startLoginRepository) private var startLoginRepository

    /// Route'u App'e verir (feature→feature coupling yok).
    private let onFinished: (SabancimRoute) -> Void
    
    private var user: RecognizedUser?

    public init(onFinished: @escaping (SabancimRoute) -> Void = { _ in }) {
        self.onFinished = onFinished
        self.user = nil
    }

    /// SplashView `.task` içinde çağırır.
    public func start() async {
        state = .checking
        let useCase = CheckVersionUseCase(repository: repository)
        let startLoginUseCase = StartLoginUseCase(repository: startLoginRepository)
        
        async let versionCheckTask = useCase(makeInput())
        async let startLoginTask = startLoginUseCase(startLogin())

        // Mock ortamda splash'i minimum 2 sn göster (aksi halde anında geçer).
        if NetworkEnvironment.current.isMock {
            try? await Task.sleep(for: .seconds(2))
        }
        
        let (versionResult, startLoginResult) = await (versionCheckTask, try? startLoginTask)
        
        if case let .success(recognizedUser) = startLoginResult {
            self.user = recognizedUser
        }

        switch versionResult {
        case .success(.upToDate):
            await route(user: user)
        case .success(.softUpdate(let storeURL)):
            state = .softUpdate(storeURL: storeURL)           // View alert gösterir
        case .success(.forceUpdate(let storeURL, let message)):
            state = .forceUpdate(storeURL: storeURL, message: message)  // bloklayan, route yok
        case .failure:
            // Toleranslı: version check açılışı bloklamamalı (karar tablosu son satır).
            await route(user: user)
        }
    }

    /// Soft update alert'inde "Sonra"ya basılınca.
    public func proceed() async {
        await route(user: user)
    }

    /// Oturum durumuna göre yönlendir (Auth'taki `AuthGate` mantığının taşınmış hali).
    private func route(user: RecognizedUser?) async {
        let target: SabancimRoute = await session.isAuthenticated ? .home : .login(name: user?.firstName)
        // İlk açılışta .onboarding kuralı istenirse buraya eklenir.
        state = .finished
        onFinished(target)
    }

    /// Sürüm bilgisini Bundle + cihazdan oku (domain saf kalsın diye burada).
    private func makeInput() -> VersionCheckInput {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return VersionCheckInput(
            applicationVersion: version,
            operatingSystem: Self.iOSOperatingSystem,
            genericContentVersion: 0,
            uuid: uuid
        )
    }

    /// Backend'in iOS için beklediği `operatingSystem` değeri — backend ile teyit et.
    private static let iOSOperatingSystem = 1
    
    private func startLogin() async -> StartLoginRequest {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let osVersion = UIDevice.current.systemVersion
        let model = UIDevice.current.model
        let request = StartLoginRequest(
            deviceUUID: uuid,
            osVersion: osVersion,
            model: model,
            appVersion: version
        )
        return request
    }
}

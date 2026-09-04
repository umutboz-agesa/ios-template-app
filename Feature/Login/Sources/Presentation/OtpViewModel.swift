//
//  OtpViewModel.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation
import Observation
import Dependencies
import CoreCommon
import CoreNavigation
import UIKit   // UIDevice.identifierForVendor

/// Android `OtpViewModel` (@HiltViewModel + StateFlow) karşılığı.
///
/// Not: `identityNumber`/`password` gerçek `confirmOtp` isteğinde KULLANILMIYOR —
/// `PasswordConfirmationParameter`'da sadece uuid/confirmationCode/source/pushToken
/// var. Yani "password neden OTP ekranına taşınıyor" sorusu hâlâ açık — bu endpoint
/// onu açıklamıyor. Şimdilik burada duruyorlar ama isteğe dahil edilmiyor.
@MainActor
@Observable
public final class OtpViewModel {
    private static let initialSeconds = 180

    public var code: String = ""
    public private(set) var remainingSeconds: Int = OtpViewModel.initialSeconds
    public private(set) var canResend: Bool = false
    /// Önceden `Loadable<Void>`'dı — `OtpConfirmationResult`'ın içeriğini (user,
    /// needsPasswordChange, userAnalyticId) tamamen atıyordu. Artık gerçek sonuç
    /// burada tutuluyor, `needsPasswordChange`'e göre farklı navigasyon kararı
    /// verilebiliyor.
    public private(set) var state: Loadable<AuthenticationResult> = .idle

    private let identityNumber: String
    private let password: String
    nonisolated(unsafe) private var countdownTask: Task<Void, Never>?
    private let onFinished: (SabancimRoute) -> Void

    @ObservationIgnored @Dependency(\.otpConfirmationRepository) private var repository
    @ObservationIgnored @Dependency(\.userSession) private var userSession

    public init(
        identityNumber: String,
        password: String,
        onFinished: @escaping (SabancimRoute) -> Void = { _ in }
    ) {
        self.identityNumber = identityNumber
        self.password = password
        self.onFinished = onFinished
    }

    public var remainingTimeText: String {
        String(format: "%02d:%02d", remainingSeconds / 60, remainingSeconds % 60)
    }

    /// TODO: gerçek kod uzunluğu netleşince (6 hane varsayıldı) düzelt.
    public var canSubmit: Bool {
        code.count == 6
    }

    public func startCountdown() {
        countdownTask?.cancel()
        remainingSeconds = Self.initialSeconds
        canResend = false
        countdownTask = Task { [weak self] in
            while let self, self.remainingSeconds > 0 {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { return }
                self.remainingSeconds -= 1
            }
            self?.canResend = true
        }
    }

    public func resend() async {
        guard canResend else { return }
        // TODO: gerçek "kodu yeniden gönder" isteği eklenince burada çağrılacak.
        startCountdown()
    }

    public func verify() async {
        state = .loading

        let useCase = ConfirmOtpUseCase(repository: repository, session: userSession)
        let request = OtpConfirmationRequest(
            confirmationCode: code,
            deviceUUID: UIDevice.current.identifierForVendor?.uuidString ?? "",
            pushToken: nil   // TODO: push notification kaydı henüz yok.
        )

        let result = await useCase(request)
        state = result.toLoadable()

        if case .success = result {
            // `confirmationResult.needsPasswordChange` true ise muhtemelen farklı
            // bir route'a (şifre değiştir ekranı) gitmek gerekiyor — henüz ele
            // alınmadı, şimdilik her zaman `.main`'e gidiyor.
            onFinished(.home)
        }
    }

    deinit {
        countdownTask?.cancel()
    }
}

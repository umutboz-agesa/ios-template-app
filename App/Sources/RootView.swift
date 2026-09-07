import SwiftUI

/// Uygulama kökü — Splash ilk ekran. Sıra: Splash → (oturuma göre) Login veya
/// doğrudan ana akış (tab'lar). Superapp'teki gerçek `RootView`'ın birebir
/// deseni: NavigationStack'i tek sabit köke (Splash) push etmek yerine, FAZ
/// DEĞİŞİNCE tüm içeriği değiştiriyoruz — bu yüzden Login'e geçince Splash'e
/// dönecek bir "geri" butonu YOK (Splash artık view hiyerarşisinde bile değil).
/// Login kendi NavigationStack'ine sahip (Login → OTP), ana akıştan bağımsız.
struct RootView: View {
    @Environment(AppNavigator.self) private var navigator

    private enum Phase {
        case splash, main
        case login(userName: String?)
    }
    @State private var phase: Phase = .splash

    /// Login stack'ine push edilecek OTP hedefi — `nil` = ekranda değil.
    private struct OtpDestination: Hashable {
        let identityNumber: String
        let password: String
    }
    @State private var otpDestination: OtpDestination?

    var body: some View {
        content
            .onChange(of: navigator.logoutRequested) { _, requested in
                guard requested else { return }
                navigator.logoutRequested = false
                navigator.popToRoot()
                otpDestination = nil
                phase = .login(userName: nil)
            }
    }

    @ViewBuilder private var content: some View {
        switch phase {
        case .splash:
            SplashView { route in
                switch route {
                case .login(let userName):
                    phase = .login(userName: userName)
                default:
                    enterMain()
                }
            }

        case .login(let name):
            NavigationStack {
                LoginView(userName: name) { route in
                    switch route {
                    case .otp(let identityNumber, let password):
                        otpDestination = OtpDestination(identityNumber: identityNumber, password: password)
                    default:
                        enterMain()
                    }
                }
                .navigationDestination(item: $otpDestination) { destination in
                    OtpView(identityNumber: destination.identityNumber, password: destination.password) { _ in
                        enterMain()
                    }
                }
            }

        case .main:
            MainTabView()
        }
    }

    private func enterMain() {
        navigator.popToRoot()
        phase = .main
    }
}

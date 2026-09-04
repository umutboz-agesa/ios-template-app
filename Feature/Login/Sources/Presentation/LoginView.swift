import SwiftUI
import DesignSystem
import CorePresentation
import CoreNavigation

/// Android `LoginScreen.kt` (Compose) karşılığı. DesignSystem component'lerini kullanır.
public struct LoginView: BaseView {
    @State private var viewModel: LoginViewModel
    private let onHelpTapped: () -> Void
    private let onContractTapped: () -> Void
    private let onBiometricLoginTapped: () -> Void

    public init(
        userName: String? = nil,
        onFinished: @escaping (SabancimRoute) -> Void = { _ in },
        onHelpTapped: @escaping () -> Void = {},
        onContractTapped: @escaping () -> Void = {},
        onBiometricLoginTapped: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: LoginViewModel(prefillUsername: userName, onFinished: onFinished))
        self.onHelpTapped = onHelpTapped
        self.onContractTapped = onContractTapped
        self.onBiometricLoginTapped = onBiometricLoginTapped
    }

    public var screenBody: some View {
        VStack(spacing: SabancimTheme.Spacing.lg) {
            header

            switch viewModel.loginType {
            case .firstLogin:
                SabancimTextField("TC/Yabancı Kimlik Numarası", text: $viewModel.username, keyboardType: .numberPad, onlyDigits: true,
                                  warning: viewModel.username.count > 11 ? "TC Kimlik Numarası 11 haneli olmalıdır." : nil)
            case .login(let name):
                SabancimGreetingHeader(title: "Merhaba, \(name)")
            }

            SabancimTextField("Şifre", text: $viewModel.password, isSecure: true,
                              warning: viewModel.password.count > 6 ? "Şifreniz 6 haneli olmalıdır." : nil)

            if case .firstLogin = viewModel.loginType {
                contractAgreementRow
            }

            if let error = viewModel.state.error {
                Text(error.userMessage)
                    .font(.footnote)
                    .foregroundStyle(SabancimTheme.Colors.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            SabancimButton("Giriş Yap", isLoading: viewModel.state.isLoading) {
                Task { await viewModel.login() }
            }
            .disabled(!viewModel.canSubmit)

            // Not: Gerçek biyometrik giriş akışı henüz YOK — bu buton şimdilik sadece
            // görsel, tıklanınca `onBiometricLoginTapped` App katmanına haber veriyor.
            // Face ID entegrasyonu (LocalAuthentication + saklı session) ayrı bir iş.
            Button(action: onBiometricLoginTapped) {
                HStack(spacing: 6) {
                    Image(systemName: "faceid")
                    Text("Face ID ile Gir")
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(SabancimTheme.Colors.primary)
            }
        }
        .padding(SabancimTheme.Spacing.lg)
        .background(SabancimTheme.Colors.background)
    }

    private var header: some View {
        HStack {
            BrandLogo(height: 20)
            Spacer()
            SabancimLinkButton("Yardım Al", action: onHelpTapped)
        }
    }

    private var contractAgreementRow: some View {
        SabancimLabeledCheckbox(isChecked: $viewModel.hasAcceptedContract) {
            // Not: link kısmı ("Kullanıcı Sözleşmesi") ayrı bir tap alanı DEĞİL —
            // tüm satır `onContractTapped`'ı tetikliyor. Bu içerik ve davranış
            // login'e özel olduğu için DesignSystem'e değil burada kalıyor.
            (
                Text("SabancıM Müşteri Mobil Uygulama ")
                + Text("Kullanıcı Sözleşmesi").underline().foregroundStyle(SabancimTheme.Colors.primary)
                + Text("'ni okudum, anladım.")
            )
            .font(.footnote)
            .foregroundStyle(SabancimTheme.Colors.muted)
            .onTapGesture(perform: onContractTapped)
        }
    }
}

#Preview {
    LoginView(userName: nil) { route in
        
    } onHelpTapped: {
        
    } onContractTapped: {
        
    } onBiometricLoginTapped: {
        
    }
}

//
//  OtpView.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import SwiftUI
import DesignSystem
import CorePresentation
import CoreNavigation

/// Android `OtpScreen.kt` (Compose) karşılığı. `LoginView` ile aynı DesignSystem
/// component'lerini ve spacing/renk kurallarını kullanır.
public struct OtpView: BaseView {
    @State private var viewModel: OtpViewModel

    public init(
        identityNumber: String,
        password: String,
        onFinished: @escaping (SabancimRoute) -> Void = { _ in }
    ) {
        _viewModel = State(initialValue: OtpViewModel(
            identityNumber: identityNumber,
            password: password,
            onFinished: onFinished
        ))
    }

    public var screenBody: some View {
        VStack(alignment: .leading, spacing: SabancimTheme.Spacing.md) {
            Text("Lütfen cep telefonunuza gelen doğrulama kodunu aşağıdaki alana girin.")
                .font(.body)
                .foregroundStyle(SabancimTheme.Colors.muted)

            Text("Kalan süreniz: \(viewModel.remainingTimeText)")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)

            SabancimTextField(
                "Cep Telefonu Doğrulama Kodu",
                text: $viewModel.code,
                keyboardType: .numberPad,
                onlyDigits: true,
                warning: viewModel.code.count > 6 ? "Doğrulama kodu 6 haneli olmalıdır." : nil
            )

            Button("Yeniden Gönder") {
                Task { await viewModel.resend() }
            }
            .disabled(!viewModel.canResend)
            .font(.footnote.weight(.semibold))
            .underline()
            // SabancimButton'daki disabled-renk sorununu burada da tekrarlamayalım —
            // sistem `Button` kendi rengini otomatik dimlemiyor, elle veriyoruz.
            .foregroundStyle(
                viewModel.canResend
                    ? SabancimTheme.Colors.primary
                    : SabancimTheme.Colors.muted.opacity(0.5)
            )
            .frame(maxWidth: .infinity, alignment: .center)

            if let error = viewModel.state.error {
                Text(error.userMessage)
                    .font(.footnote)
                    .foregroundStyle(SabancimTheme.Colors.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            SabancimButton("Devam", isLoading: viewModel.state.isLoading) {
                Task { await viewModel.verify() }
            }
            .disabled(!viewModel.canSubmit)
        }
        .padding(SabancimTheme.Spacing.lg)
        .background(SabancimTheme.Colors.background)
        .navigationTitle("Cep Telefonu Doğrulama")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.startCountdown()
        }
    }
}

#Preview {
    OtpView(identityNumber: "", password: "") { _ in
        
    }
}

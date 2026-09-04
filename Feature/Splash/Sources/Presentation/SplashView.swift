import SwiftUI
import DesignSystem
import CorePresentation
import CoreNavigation
import Foundation
import SwiftUI
import UIKit
import DesignSystem
import CoreNavigation

/// Android `SplashScreen` / legacy `SplashViewController` karşılığı.
public struct SplashView: BaseView {
    @State private var viewModel: SplashViewModel
    @Environment(\.openURL) private var openURL

    public init(onFinished: @escaping (SabancimRoute) -> Void = { _ in }) {
        _viewModel = State(initialValue: SplashViewModel(onFinished: onFinished))
    }

    public var screenBody: some View {
        ZStack {
            background
            content
        }
        .alert("Güncelleme mevcut", isPresented: softUpdateBinding) {
            Button("Güncelle") {
                if case let .softUpdate(url) = viewModel.state { openURL(url) }
            }
            Button("Sonra", role: .cancel) {
                Task { await viewModel.proceed() }
            }
        } message: {
            Text("Yeni bir sürüm mevcut. Şimdi güncellemek ister misiniz?")
        }
        .task { await viewModel.start() }
    }

    // MARK: - Arka plan
    @ViewBuilder private var background: some View {
        Image("LaunchImage")
            .resizable()
            .ignoresSafeArea()
    }

    // MARK: - İçerik
    @ViewBuilder private var content: some View {
        switch viewModel.state {
        case .forceUpdate(let storeURL, let message):
            forceUpdateView(storeURL: storeURL, message: message)
        default:
            splashOverlay
        }
    }

    private var splashOverlay: some View {
        VStack(spacing: SabancimTheme.Spacing.lg) {
            Spacer()
            ProgressView()
                .tint(SabancimTheme.Colors.primary)
                .padding(.bottom, SabancimTheme.Spacing.lg)
        }
    }

    private func forceUpdateView(storeURL: URL, message: String) -> some View {
        VStack(spacing: SabancimTheme.Spacing.md) {
            Spacer()
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.white)
            Text("Güncelleme Gerekli")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.85))
            Spacer()
            SabancimButton("App Store'a Git") { openURL(storeURL) }
        }
        .padding(SabancimTheme.Spacing.lg)
        .background(.black.opacity(0.35))   // metin okunurluğu için
    }

    private var softUpdateBinding: Binding<Bool> {
        Binding(
            get: { if case .softUpdate = viewModel.state { true } else { false } },
            set: { _ in }
        )
    }
}

#Preview {
    SplashView()
}

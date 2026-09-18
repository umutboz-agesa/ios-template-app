import SwiftUI

/// Login/OTP sonrası düşülen ekran. `UserSession`'dan gelen gerçek profille
/// karşılıyor, `SessionManaging.clear()` + `UserSession.signOut()` ile gerçek
/// çıkış yapıyor. "Birikimlerim" kartı superapp'in kendi tasarım sistemi
/// component'i (`SabancimSavingsOverviewCard` — donut grafik + 2x2 kırılım)
/// ile, superapp'ten birebir taşınan gerçek servise bağlı gösteriliyor.
public struct HomeView: BaseView {
    @State private var viewModel: HomeViewModel
    @Environment(AppNavigator.self) private var navigator

    public init(onFinished: @escaping (AppRoute) -> Void = { _ in }) {
        _viewModel = State(initialValue: HomeViewModel(onFinished: onFinished))
    }

    public var screenBody: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                header

                savingsCard
            }
            .padding(AppTheme.Spacing.lg)
        }
        .background(AppTheme.Colors.background)
        .task { await viewModel.loadSummary() }
    }

    /// Selamlama + Profil'e giriş noktası (superapp'te dişli genelde Profil'in
    /// kendi üst barında; burada Home'dan da tek dokunuşla erişilebiliyor).
    private var header: some View {
        HStack(alignment: .top) {
            SabancimGreetingHeader(
                title: "Merhaba, \(viewModel.profile.firstName)",
                subtitle: "Oturumunuz açık — buraya kendi feature'larınızı ekleyin."
            )
            Spacer(minLength: AppTheme.Spacing.sm)
            SabancimIconButton(systemName: "person") {
                navigator.push(.profile)
            }
            .accessibilityLabel("Profilim")
        }
    }

    @ViewBuilder
    private var savingsCard: some View {
        switch viewModel.summaryState {
        case .idle, .loading:
            LoadingView()
                .frame(height: 220)
        case .failed(let error):
            ErrorView(message: error.userMessage, onRetry: { Task { await viewModel.loadSummary() } })
                .frame(height: 220)
        case .loaded:
            SabancimSavingsOverviewCard(
                total: viewModel.savingsTotal,
                slices: viewModel.savingsSlices,
                activeCount: viewModel.savingsActiveCount
            )
        }
    }
}

// `@Environment(AppNavigator.self)` enjekte edilmeden Canvas bu dosyayı
// render etmeye çalışırsa SwiftUI kasıtlı olarak crash eder (eksik Observable
// environment değeri). Diğer ekranlardaki (`ProfileView` vb.) desenle aynı:
// preview'a environment'ı burada elle sağlıyoruz.
#Preview {
    HomeView()
        .environment(AppNavigator())
}

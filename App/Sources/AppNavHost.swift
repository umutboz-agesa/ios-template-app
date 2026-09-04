import SwiftUI
import DesignSystem
import CoreNavigation

/// Android `SabancimNavHost.kt` (Navigation Compose) karşılığı — Home tab'ının
/// `NavigationStack`'i + route → screen eşlemesi. Superapp'ten birebir; sadece
/// bu template'te olmayan feature'lara ait case'ler `appRouteScreen`'in
/// `default` dalına düşüyor (bkz. orada not).
struct AppNavHost: View {
    @Environment(AppNavigator.self) private var navigator

    var body: some View {
        @Bindable var nav = navigator
        NavigationStack(path: $nav.path) {
            home
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    SabancimTabBar(selection: $nav.selectedTab,
                                   menuItemID: AppTab.explore.rawValue,
                                   menuActive: nav.showExplore,
                                   onMenuTap: { nav.showExplore = true })
                }
                .gesture(tabSwipeGesture(nav))
                .navigationDestination(for: SabancimRoute.self) { route in
                    if route == .home {
                        home
                    } else {
                        appRouteScreen(for: route, onRoute: go)
                    }
                }
        }
    }

    /// Home tek yerde kurulur (tekrar yok); tıklamalar merkezi `appNavigate`'ten geçer.
    private var home: some View {
        HomeView(onFinished: go)
            .toolbar(.hidden, for: .navigationBar)   // HomeView kendi üst bar'ına sahip
    }

    private func go(_ route: SabancimRoute) {
        appNavigate(route, navigator: navigator, push: { navigator.push($0) })
    }
}

/// Merkezi navigasyon kararı — TÜM ekranlar/sekmeler bunu kullanır (tek kaynak).
/// Route bir tab'a aitse (Birikimlerim/Sağlığım/Aracım) **sekme değiştirir**;
/// değilse (detay ekranı, ör. Profil/Ayarlar) mevcut stack'e push eder.
@MainActor
func appNavigate(_ route: SabancimRoute, navigator: AppNavigator, push: (SabancimRoute) -> Void) {
    if let tab = AppTab(route: route) {
        navigator.selectedTab = tab.rawValue
    } else {
        push(route)
    }
}

/// Kök ekranlarda sağ/sol yatay kaydırma ile sekme değiştirir (düşük öncelikli;
/// dikey scroll gibi alt jestler önce kazanır).
@MainActor
func tabSwipeGesture(_ navigator: AppNavigator) -> some Gesture {
    DragGesture(minimumDistance: 20)
        .onEnded { value in
            let dx = value.translation.width
            let dy = value.translation.height
            guard abs(dx) > 70, abs(dx) > abs(dy) * 1.5 else { return }
            let last = AppTab.allCases.count - 1
            withAnimation(.easeInOut(duration: 0.2)) {
                if dx < 0 {
                    navigator.selectedTab = min(navigator.selectedTab + 1, last)
                } else {
                    navigator.selectedTab = max(navigator.selectedTab - 1, 0)
                }
            }
        }
}

/// Merkezi route → ekran eşlemesi (App katmanında tek kaynak). Hem `AppNavHost`
/// (Home stack'i) hem `RootTab` (diğer sekmeler) bunu kullanır → tekrar yok.
///
/// NOT: superapp'teki gerçek switch çok daha geniş (Health/Vehicle/Savings/
/// Payment/Claims/Notifications vb.) — bu template'te sadece Profile/Settings
/// gerçek feature. Kendi feature'ınızı eklerken buraya bir case daha ekleyin.
@MainActor
@ViewBuilder
func appRouteScreen(for route: SabancimRoute, onRoute: @escaping (SabancimRoute) -> Void) -> some View {
    switch route {
    case .profile:
        ProfileView(onRoute: onRoute)
            .toolbar(.hidden, for: .navigationBar)
    case .settings:
        SettingsView(onRoute: onRoute)
            .toolbar(.hidden, for: .navigationBar)
    default:
        Text("Route: \(String(describing: route)) — henüz bağlanmadı")
            .foregroundStyle(.secondary)
            .navigationTitle(String(describing: route))
    }
}

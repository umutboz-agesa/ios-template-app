import SwiftUI

/// Merkezi sekme navigasyon kabı — TÜM (Home dışı) sekmeler bunu kullanır (tek
/// kaynak, kod tekrarı yok). Kendi `NavigationStack` + path'i vardır. Tıklamalar
/// merkezi `appNavigate`'ten geçer: tab'a ait route → sekme değiştir; detay
/// route → bu stack'e push. Superapp'ten birebir.
struct RootTab<Root: View>: View {
    @Environment(AppNavigator.self) private var navigator
    private let root: (@escaping (AppRoute) -> Void) -> Root
    @State private var path = NavigationPath()

    init(@ViewBuilder root: @escaping (@escaping (AppRoute) -> Void) -> Root) {
        self.root = root
    }

    private func go(_ route: AppRoute) {
        appNavigate(route, navigator: navigator, push: { path.append($0) })
    }

    var body: some View {
        @Bindable var nav = navigator
        NavigationStack(path: $path) {
            root(go)
                .toolbar(.hidden, for: .navigationBar)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    AppTabBar(selection: $nav.selectedTab,
                                   menuItemID: AppTab.explore.rawValue,
                                   menuActive: nav.showExplore,
                                   onMenuTap: { nav.showExplore = true })
                }
                .gesture(tabSwipeGesture(navigator))
                .navigationDestination(for: AppRoute.self) { route in
                    appRouteScreen(for: route, onRoute: go)
                }
        }
    }
}

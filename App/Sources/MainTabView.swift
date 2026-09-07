import SwiftUI

/// Ana tab bar shell'i. Her sekme merkezi `RootTab` kabını kullanır → navigasyon
/// tek yerden yönetilir, kod tekrarı yok. (Home, derin link için global
/// navigator'lu `AppNavHost`.) Superapp'ten birebir; Birikimlerim/Sağlığım/
/// Aracım bu template'te boş placeholder — kendi feature'ınızı yazınca
/// `RootTab { ... }` içindeki view'ı değiştirin.
struct MainTabView: View {
    @Environment(AppNavigator.self) private var navigator

    var body: some View {
        @Bindable var nav = navigator
        // Native tab bar gizli; altta özel SabancimTabBar (redesign) kullanılıyor.
        TabView(selection: $nav.selectedTab) {
            AppNavHost()
                .tag(AppTab.home.rawValue)
                .toolbar(.hidden, for: .tabBar)

            RootTab { _ in EmptyFeaturePlaceholder(title: "Birikimlerim") }
                .tag(AppTab.savings.rawValue)
                .toolbar(.hidden, for: .tabBar)

            RootTab { _ in EmptyFeaturePlaceholder(title: "Sağlığım") }
                .tag(AppTab.health.rawValue)
                .toolbar(.hidden, for: .tabBar)

            RootTab { _ in EmptyFeaturePlaceholder(title: "Aracım") }
                .tag(AppTab.vehicle.rawValue)
                .toolbar(.hidden, for: .tabBar)
        }
        .sheet(isPresented: $nav.showExplore) { EmptyExploreSheet() }
    }
}

/// Henüz yazılmamış bir sekme için boş durum ekranı. Kendi feature'ınızı
/// bağlayınca yukarıdaki ilgili `RootTab { ... }` çağrısını değiştirip bunu
/// kaldırın.
private struct EmptyFeaturePlaceholder: View {
    let title: String

    var body: some View {
        VStack(spacing: SabancimTheme.Spacing.md) {
            Image(systemName: "hammer")
                .font(.system(size: 40))
                .foregroundStyle(SabancimTheme.Colors.muted)
            Text(title)
                .font(.title3.bold())
            Text("Bu sekme henüz eklenmedi.")
                .font(.footnote)
                .foregroundStyle(SabancimTheme.Colors.muted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SabancimTheme.Colors.background)
    }
}

/// "Keşfet" menüsü — superapp'te FeatureProducts'a bağlı gerçek bir sheet;
/// bu template'te boş placeholder.
private struct EmptyExploreSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            EmptyFeaturePlaceholder(title: "Keşfet")
                .navigationTitle("Keşfet")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Kapat") { dismiss() }
                    }
                }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

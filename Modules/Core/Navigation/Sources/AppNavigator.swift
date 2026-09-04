import Foundation
import Observation

/// Android `:core:navigation` `AppNavigator` (event bus) karşılığı.
///
/// Feature'lar birbirini import edemez (yasak bağlantı). Bir feature başka bir
/// feature'a gitmek istediğinde `AppNavigator` üzerinden route yayınlar; App
/// katmanındaki `NavigationStack` bunu dinler. Böylece `Feature:X → Feature:Y`
/// derleme-zamanı bağımlılığı oluşmaz.
@MainActor
@Observable
public final class AppNavigator {
    // NavigationStack(path:) iki yönlü binding ister; SwiftUI kullanıcı geri
    // gittiğinde path'i kendisi günceller. Bu yüzden setter public olmalı
    // (private(set) olsa `$nav.path` binding'i "setter inaccessible" verir).
    // Uygulama içi mutation yine push/pop/replaceStack üzerinden yapılır.
    public var path: [SabancimRoute] = []

    /// Seçili alt tab (TabView selection). Tab'a ait route'lar buraya yazılır → sekme switch.
    public var selectedTab: Int = AppTab.home.rawValue

    /// Login sonrası devam edilecek bekleyen deep-link hedefi (Android `PendingDeepLink`).
    public var pendingTarget: SabancimRoute?

    /// Keşfet menüsü (alt sheet) açık mı — tab yerine sheet gösterilir.
    public var showExplore = false

    public init() {}

    public func push(_ route: SabancimRoute) { path.append(route) }
    public func pop() { _ = path.popLast() }
    public func popToRoot() { path.removeAll() }

    /// Çıkış (logout) isteği — ProfileView tetikler, RootView dinleyip Login'e döner.
    public var logoutRequested = false
    public func requestLogout() { logoutRequested = true }

    public func replaceStack(with route: SabancimRoute) {
        path = [route]
    }

    /// Deep-link geldiğinde auth gate çözene kadar tut.
    public func setPendingDeepLink(_ route: SabancimRoute) {
        pendingTarget = route
    }

    public func consumePendingDeepLink() -> SabancimRoute? {
        defer { pendingTarget = nil }
        return pendingTarget
    }
}

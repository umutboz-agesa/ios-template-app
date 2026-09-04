import Foundation

/// Android `:core:navigation` `SabancimRoute` (type-safe routes) karşılığı.
/// SwiftUI `NavigationStack` + `NavigationPath` ile type-safe yönlendirme için
/// `Hashable` enum. Feature'lar buraya bağımlıdır, birbirine değil.
public enum SabancimRoute: Hashable, Sendable {
    case splash
    case onboarding
    case login(name: String?)
    case otp(identityNumber: String, password: String)
    case home
    case productList
    case productDetail(productCode: String)
    case calculator
    case pension
    case health
    case vehicle
    case policies
    case claims
    case payment
    case notifications
    case profile
    case settings
    case savings
    case savingsDetail(contractCode: String, packageCode: String, participantStatus: Int, owner: String)
    case besPurchase
    case news
    case opportunities
    case healthInstitutions
    case lifeInsuranceDetail
    case daskDetail
    case support
}

/// Hangi route'ların authentication gerektirdiği (Android `RouteSecurity.requiresAuth`).
public enum RouteSecurity {
    public static func requiresAuth(_ route: SabancimRoute) -> Bool {
        switch route {
        case .splash, .onboarding, .login, .otp:
            false
        case .home, .productList, .productDetail, .calculator, .pension, .news, .opportunities, .health, .vehicle, .policies, .claims, .payment, .notifications, .profile, .settings, .savings, .savingsDetail, .besPurchase, .healthInstitutions, .lifeInsuranceDetail, .daskDetail, .support:
            true
        }
    }
}


/// Alt tab bar sekmeleri. Bir route bir tab'a aitse (init? nil değilse) navigasyon
/// push yerine **sekme değiştirir** — ör. slider'dan Sağlığım'a gidince Sağlığım tab'ı açılır.
public enum AppTab: Int, Sendable, CaseIterable {
    case home = 0
    case savings
    case health
    case vehicle
    case explore

    public init?(route: SabancimRoute) {
        switch route {
        case .home:    self = .home
        case .savings: self = .savings
        case .health:  self = .health
        case .vehicle: self = .vehicle
        default:             return nil   // detay ekranı → mevcut stack'e push
        }
    }
}

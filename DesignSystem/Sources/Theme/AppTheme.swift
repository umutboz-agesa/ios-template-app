import SwiftUI

/// Uygulama teması — kullanıcı seçimi (Ayarlar > Uygulama > Tema).
/// `@AppStorage("app_theme")` ile saklanır; kök view `preferredColorScheme` uygular,
/// böylece uygulamadan çıkmadan **runtime**'da değişir (tek anahtar → her yer senkron).
public enum AppTheme: String, CaseIterable, Identifiable, Sendable {
    case system   // Varsayılan (cihaz ayarı)
    case light    // Açık
    case dark     // Koyu

    public var id: String { rawValue }

    /// Ayarlar ekranında görünen ad.
    public var title: String {
        switch self {
        case .system: return "Varsayılan"
        case .light:  return "Açık"
        case .dark:   return "Koyu"
        }
    }

    /// SwiftUI `preferredColorScheme` değeri (system → nil = cihazı takip et).
    public var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

/// `@AppStorage` için ortak anahtar (App kökü ve Ayarlar aynı anahtarı kullanır).
public enum AppThemeStorage {
    public static let key = "app_theme"
}

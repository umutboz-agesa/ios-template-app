import SwiftUI

// Home ekranı için SabancimTheme genişletmeleri.
// Mevcut SabancimTheme.swift'e dokunmadan, extension'larla eklenir (tek kaynak, tekrar yok).

public extension SabancimTheme.Colors {
    /// Trend artışı / pozitif (↑ %12,4).
    static let success = Color(red: 0.13, green: 0.70, blue: 0.42)
    /// Gradyan/renkli zemin üstünde ikincil beyaz metin.
    static let onPrimaryMuted = Color.white.opacity(0.85)
    /// Pasif tab / ikincil ikon.
    static let tabInactive = Color(.tertiaryLabel)
    /// Kart yüzeyi (beyaz kartlar) — sistem arka planından ayrışsın.
    static let cardSurface = Color(.systemBackground)
    /// Bildirim / uyarı vurgusu (badge) — Sabancım turuncusu.
    static let notification = Color(red: 0.98, green: 0.53, blue: 0.11)
}

public extension SabancimTheme.Spacing {
    static let xl: CGFloat = 32
}

public extension SabancimTheme.Radius {
    /// Chip / pill.
    static let pill: CGFloat = 999
    /// Kategori tile / büyük kart.
    static let tile: CGFloat = 20
}

public extension SabancimTheme {

    /// Gradyan token'ları (promo banner vb.).
    enum Gradients {
        public static let promo = LinearGradient(
            colors: [
                Color(red: 0.16, green: 0.22, blue: 0.75),
                Color(red: 0.29, green: 0.45, blue: 0.96),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        /// Sayfa arka planı — açık lavanta degrade (üst açık → alt lavanta). Kartlar beyaz kalır.
        public static let appBackground = LinearGradient(
            colors: [
                Color(red: 0.960, green: 0.960, blue: 0.992),
                Color(red: 0.909, green: 0.902, blue: 0.980),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Tipografi ölçeği — component'ler `.font(SabancimTheme.Typography.x)` kullanır.
    enum Typography {
        public static let greeting = Font.title2.bold()
        public static let amount = Font.system(size: 28, weight: .bold, design: .rounded)
        public static let cardTitle = Font.headline
        public static let sectionTitle = Font.title3.bold()
        public static let tileLabel = Font.caption
        public static let caption = Font.footnote
    }

    /// Kart gölge token'ları (SabancimCard tek yerden uygular).
    enum Shadow {
        public static let cardColor = Color.black.opacity(0.06)
        public static let cardRadius: CGFloat = 12
        public static let cardY: CGFloat = 4
    }
}

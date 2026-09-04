import SwiftUI

/// Merkezi marka renk paleti — uygulamadaki TÜM marka renkleri tek kaynaktan gelir.
/// Feature'larda inline `Color(red:...)` YASAK; hepsi buradan çekilir → tek noktadan
/// değiştirilebilir + tema-duyarlı yüzeyler dark/açık'ta otomatik uyum sağlar.
///
/// NOT: Bu template'te değerler bilerek SwiftUI'nin standart, tema-duyarlı
/// sistem renklerine (`Color.blue`, `Color.green` vb.) çekildi — belirli bir
/// markanın hex kodları değil, jenerik bir başlangıç noktası. Kendi
/// marka renklerinizi uygularken sadece bu dosyadaki değerleri değiştirin;
/// aşağıdaki isimler (API) sabit kalsın ki tüketen kod hiç değişmesin.
public extension SabancimTheme {
    enum Brand {
        // MARK: - Solid accent'ler (ikon/rozet/buton/chip) — marka kimliği, iki temada da aynı
        // TODO: Kendi marka renklerinizle değiştirin.
        public static let blue   = Color.blue
        public static let green  = Color.green
        public static let red    = Color.red
        public static let purple = Color.purple
        public static let orange = SabancimTheme.Colors.notification
        public static let indigo = Color.indigo

        // MARK: - Marka gradyanları (promo banner / renkli kart)
        public static let blueGradient = LinearGradient(
            colors: [blue, blue.opacity(0.7)],
            startPoint: .topLeading, endPoint: .bottomTrailing)
        public static let greenGradient = LinearGradient(
            colors: [green, green.opacity(0.7)],
            startPoint: .topLeading, endPoint: .bottomTrailing)
        public static let redGradient = LinearGradient(
            colors: [red, red.opacity(0.7)],
            startPoint: .topLeading, endPoint: .bottomTrailing)
        public static let purpleGradient = LinearGradient(
            colors: [purple, purple.opacity(0.7)],
            startPoint: .topLeading, endPoint: .bottomTrailing)

        // MARK: - Tema-duyarlı yumuşak yüzey tint'leri (markalı kart arka planı)
        // `opacity` ile sistem rengi üzerinden türetildi — açık/koyu temada
        // otomatik uyum sağlar, ayrı ayrı RGB çifti bakımı gerekmez.
        public static func blueSurface(_ scheme: ColorScheme) -> Color {
            blue.opacity(scheme == .dark ? 0.22 : 0.10)
        }
        public static func greenSurface(_ scheme: ColorScheme) -> Color {
            green.opacity(scheme == .dark ? 0.22 : 0.10)
        }
        public static func redSurface(_ scheme: ColorScheme) -> Color {
            red.opacity(scheme == .dark ? 0.22 : 0.10)
        }
        public static func orangeSurface(_ scheme: ColorScheme) -> Color {
            orange.opacity(scheme == .dark ? 0.22 : 0.10)
        }
    }
}

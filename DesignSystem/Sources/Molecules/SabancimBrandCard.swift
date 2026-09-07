import SwiftUI

/// Marka bölüm kartı — "Ürün & Hizmetler" ekranındaki AGESA/MEDISA/AKSİGORTA blokları.
///
/// DesignSystem kuralı: model DEĞİL düz parametre alır. Zemin (`background`) hem düz renk
/// hem gradyan olabilsin diye `AnyShapeStyle` alır. `onDark` = koyu/renkli zeminde beyaz metin
/// düzeni (AKSİGORTA kırmızı kartı) — rozet ve filigran ona göre ayarlanır.
public struct SabancimBrandCard<Content: View>: View {
    private let badge: String?
    private let title: String
    private let subtitle: String?
    private let background: AnyShapeStyle
    private let foreground: Color
    private let accent: Color
    private let watermark: String?
    private let onDark: Bool
    private let content: Content

    public init(
        badge: String? = nil,
        title: String,
        subtitle: String? = nil,
        background: AnyShapeStyle,
        foreground: Color = SabancimTheme.Colors.onSurface,
        accent: Color = SabancimTheme.Colors.primary,
        watermark: String? = nil,
        onDark: Bool = false,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.badge = badge
        self.title = title
        self.subtitle = subtitle
        self.background = background
        self.foreground = foreground
        self.accent = accent
        self.watermark = watermark
        self.onDark = onDark
        self.content = content()
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            if let watermark {
                Image(systemName: watermark)
                    .font(.system(size: 96))
                    .foregroundStyle(foreground.opacity(onDark ? 0.16 : 0.08))
                    .offset(x: 18, y: -4)
                    .allowsHitTesting(false)
            }

            VStack(alignment: .leading, spacing: SabancimTheme.Spacing.sm) {
                if let badge { badgeChip(badge) }

                Text(title)
                    .font(.headline)                       // DS başlık ölçeği (mockup'takinden küçük)
                    .foregroundStyle(foreground)
                    .fixedSize(horizontal: false, vertical: true)

                if let subtitle {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(onDark ? Color.white.opacity(0.9) : SabancimTheme.Colors.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }

                content
                    .padding(.top, SabancimTheme.Spacing.xs)
            }
            .padding(SabancimTheme.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.tile, style: .continuous))
    }

    private func badgeChip(_ text: String) -> some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .tracking(0.5)
            .foregroundStyle(onDark ? .white : accent)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(onDark ? Color.white.opacity(0.20) : accent.opacity(0.12))
            .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 16) {
        SabancimBrandCard(
            badge: "AGESA",
            title: "Geleceğinizi Güvenceye Alın",
            background: AnyShapeStyle(Color(red: 0.93, green: 0.95, blue: 1.0)),
            accent: Color(red: 0.12, green: 0.40, blue: 0.90),
            watermark: "banknote.fill"
        ) {
            Text("• içerik slotu")
        }
        SabancimBrandCard(
            badge: "AKSİGORTA GÜVENCESİ",
            title: "Tüm Sigortalarınız Tek Çatı Altında",
            subtitle: "Aracınız, eviniz, sevdikleriniz ve kendiniz için ihtiyacınız olan tüm sigortalar burada.",
            background: AnyShapeStyle(LinearGradient(colors: [Color(red: 0.82, green: 0.13, blue: 0.20), Color(red: 0.72, green: 0.10, blue: 0.28)], startPoint: .topLeading, endPoint: .bottomTrailing)),
            foreground: .white,
            onDark: true
        )
    }
    .padding()
}

import SwiftUI

/// Geçici "yakında" placeholder ekranı — henüz yapılmamış feature template'leri için.
/// Tek yerden parametreyle kullanılır (Sağlığım/Arabam/Birikimlerim/Kampanyalar) → tekrar yok.
public struct SabancimComingSoonView: View {
    private let systemImage: String
    private let title: String
    private let subtitle: String

    public init(systemImage: String, title: String, subtitle: String = "Yakında") {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(spacing: SabancimTheme.Spacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 52))
                .foregroundStyle(SabancimTheme.Colors.primary)
            Text(title)
                .font(SabancimTheme.Typography.sectionTitle)
                .foregroundStyle(SabancimTheme.Colors.onSurface)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(SabancimTheme.Colors.muted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
    }
}

#Preview {
    SabancimComingSoonView(systemImage: "heart.fill", title: "Sağlığım")
}

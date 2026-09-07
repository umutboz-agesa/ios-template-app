import SwiftUI

/// Beyaz yüzeyli, köşesi yuvarlatılmış, hafif gölgeli kart container'ı.
/// Home'daki tüm kartların temeli — gölge/radius tek yerden gelir (tekrar yok).
public struct SabancimCard<Content: View>: View {
    private let padding: CGFloat
    private let content: Content

    public init(padding: CGFloat = SabancimTheme.Spacing.md, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(SabancimTheme.Colors.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.tile, style: .continuous))
            .shadow(color: SabancimTheme.Shadow.cardColor,
                    radius: SabancimTheme.Shadow.cardRadius,
                    x: 0, y: SabancimTheme.Shadow.cardY)
    }
}

#Preview {
    SabancimCard {
        VStack(alignment: .leading, spacing: 8) {
            Text("Kart başlığı").font(SabancimTheme.Typography.cardTitle)
            Text("Kart içeriği").foregroundStyle(SabancimTheme.Colors.muted)
        }
    }
    .padding()
    .background(Color(.secondarySystemBackground))
}

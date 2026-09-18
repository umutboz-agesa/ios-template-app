import SwiftUI

/// Beyaz yüzeyli, köşesi yuvarlatılmış, hafif gölgeli kart container'ı.
/// Home'daki tüm kartların temeli — gölge/radius tek yerden gelir (tekrar yok).
public struct SabancimCard<Content: View>: View {
    private let padding: CGFloat
    private let content: Content

    public init(padding: CGFloat = AppTheme.Spacing.md, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.Colors.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.tile, style: .continuous))
            .shadow(color: AppTheme.Shadow.cardColor,
                    radius: AppTheme.Shadow.cardRadius,
                    x: 0, y: AppTheme.Shadow.cardY)
    }
}

#Preview {
    SabancimCard {
        VStack(alignment: .leading, spacing: 8) {
            Text("Kart başlığı").font(AppTheme.Typography.cardTitle)
            Text("Kart içeriği").foregroundStyle(AppTheme.Colors.muted)
        }
    }
    .padding()
    .background(Color(.secondarySystemBackground))
}

import SwiftUI

/// Navigasyon liste satırı — ikon + başlık + sağ chevron, beyaz kart, tıklanabilir.
/// Sağlığım/menü tarzı "bir sonraki ekrana git" satırları için (açılır DEĞİL).
public struct SabancimNavListRow: View {
    private let icon: String
    private let iconColor: Color
    private let title: String
    private let onTap: () -> Void

    public init(
        icon: String,
        iconColor: Color = SabancimTheme.Colors.primary,
        title: String,
        onTap: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: SabancimTheme.Spacing.sm + 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(iconColor)
                    .frame(width: 26)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(SabancimTheme.Colors.tabInactive)
            }
            .padding(.horizontal, SabancimTheme.Spacing.md)
            .padding(.vertical, SabancimTheme.Spacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(SabancimTheme.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.card, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 8) {
        SabancimNavListRow(icon: "building.2.fill", title: "Anlaşmalı Sağlık Kurumları")
        SabancimNavListRow(icon: "target", iconColor: .purple, title: "Teminat ve Limitlerim")
        SabancimNavListRow(icon: "dollarsign.square.fill", iconColor: .green, title: "Sağlık Harcamalarım")
    }
    .padding()
    .background(Color(.secondarySystemBackground))
}

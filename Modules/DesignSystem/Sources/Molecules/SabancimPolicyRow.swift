import SwiftUI

/// Poliçe/sözleşme satırı — rozet + başlık + "Bitiş: …" + sağ chevron. Beyaz kart + gölge, tıklanabilir.
/// "Poliçelerim / Sözleşmelerim" gibi listelerde kullanılır. DS molecule: düz parametre.
public struct SabancimPolicyRow: View {
    private let badge: String
    private let accent: Color
    private let title: String
    private let meta: String
    private let onTap: () -> Void

    public init(
        badge: String,
        accent: Color = SabancimTheme.Colors.primary,
        title: String,
        meta: String,
        onTap: @escaping () -> Void = {}
    ) {
        self.badge = badge
        self.accent = accent
        self.title = title
        self.meta = meta
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: SabancimTheme.Spacing.md) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(badge)
                        .font(.caption2.weight(.bold))
                        .tracking(0.5)
                        .foregroundStyle(accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(accent.opacity(0.12))
                        .clipShape(Capsule())
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(SabancimTheme.Colors.onSurface)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(meta)
                        .font(.footnote)
                        .foregroundStyle(SabancimTheme.Colors.muted)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(SabancimTheme.Colors.tabInactive)
            }
            .padding(SabancimTheme.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(SabancimTheme.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.tile, style: .continuous))
        .shadow(color: SabancimTheme.Shadow.cardColor,
                radius: SabancimTheme.Shadow.cardRadius, y: SabancimTheme.Shadow.cardY)
    }
}

#Preview {
    VStack(spacing: 12) {
        SabancimPolicyRow(badge: "Aksigorta", title: "Tamamlayıcı Sağlık Sigortası", meta: "Bitiş: 14.10.2026")
        SabancimPolicyRow(badge: "AgeSA", title: "Bireysel Emeklilik (BES)", meta: "Bitiş: Süresiz")
    }
    .padding()
    .background(Color(.secondarySystemBackground))
}

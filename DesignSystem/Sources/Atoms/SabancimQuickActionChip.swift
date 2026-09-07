import SwiftUI

/// Hızlı işlem kartı — dikey: üstte dairesel tonlu ikon, altında ortalı etiket (2 satır).
/// `tint` ile ikon rengi ayrışır (mavi/turuncu/yeşil).
public struct SabancimQuickActionChip: View {
    private let systemName: String
    private let title: String
    private let tint: Color
    private let action: () -> Void

    public init(systemName: String,
                title: String,
                tint: Color = SabancimTheme.Colors.primary,
                action: @escaping () -> Void) {
        self.systemName = systemName
        self.title = title
        self.tint = tint
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: SabancimTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: systemName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(tint)
                }
                Text(title)
                    .font(.footnote.weight(.regular))
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, SabancimTheme.Spacing.md)
            .padding(.horizontal, SabancimTheme.Spacing.sm)
            .frame(minHeight: 128)
            .background(SabancimTheme.Colors.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.tile, style: .continuous))
            .shadow(color: SabancimTheme.Shadow.cardColor,
                    radius: SabancimTheme.Shadow.cardRadius,
                    x: 0, y: SabancimTheme.Shadow.cardY)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 12) {
        SabancimQuickActionChip(systemName: "doc.text", title: "Poliçelerim / Sözleşmelerim") {}
        SabancimQuickActionChip(systemName: "exclamationmark.triangle", title: "Hasar İhbarı", tint: SabancimTheme.Colors.notification) {}
        SabancimQuickActionChip(systemName: "creditcard", title: "Ödeme Yap", tint: SabancimTheme.Colors.success) {}
    }
    .padding()
    .background(Color(.secondarySystemBackground))
}

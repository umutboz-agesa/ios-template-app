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
                tint: Color = AppTheme.Colors.primary,
                action: @escaping () -> Void) {
        self.systemName = systemName
        self.title = title
        self.tint = tint
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.md) {
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
                    .foregroundStyle(AppTheme.Colors.onSurface)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .frame(minHeight: 128)
            .background(AppTheme.Colors.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.tile, style: .continuous))
            .shadow(color: AppTheme.Shadow.cardColor,
                    radius: AppTheme.Shadow.cardRadius,
                    x: 0, y: AppTheme.Shadow.cardY)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 12) {
        SabancimQuickActionChip(systemName: "doc.text", title: "Poliçelerim / Sözleşmelerim") {}
        SabancimQuickActionChip(systemName: "exclamationmark.triangle", title: "Hasar İhbarı", tint: AppTheme.Colors.notification) {}
        SabancimQuickActionChip(systemName: "creditcard", title: "Ödeme Yap", tint: AppTheme.Colors.success) {}
    }
    .padding()
    .background(Color(.secondarySystemBackground))
}

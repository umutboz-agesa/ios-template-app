import SwiftUI

/// Bildirim satırı — tint'li ikon + başlık + mesaj + zaman, sağda okunmadı noktası.
/// Beyaz kart + gölge, tıklanabilir. DS molecule: düz parametre.
public struct SabancimNotificationRow: View {
    private let icon: String
    private let iconColor: Color
    private let title: String
    private let message: String
    private let time: String
    private let isUnread: Bool
    private let onTap: () -> Void

    public init(
        icon: String,
        iconColor: Color = SabancimTheme.Colors.primary,
        title: String,
        message: String,
        time: String,
        isUnread: Bool = false,
        onTap: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.message = message
        self.time = time
        self.isUnread = isUnread
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: SabancimTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(iconColor)
                    .frame(width: 42, height: 42)
                    .background(iconColor.opacity(0.15))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .firstTextBaseline, spacing: SabancimTheme.Spacing.sm) {
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(SabancimTheme.Colors.onSurface)
                        Spacer(minLength: 0)
                        if isUnread {
                            Circle()
                                .fill(SabancimTheme.Colors.notification)
                                .frame(width: 8, height: 8)
                        }
                    }
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(SabancimTheme.Colors.muted)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(time)
                        .font(.caption2)
                        .foregroundStyle(SabancimTheme.Colors.tabInactive)
                        .padding(.top, 1)
                }
            }
            .padding(SabancimTheme.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(SabancimTheme.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.card, style: .continuous))
        .shadow(color: SabancimTheme.Shadow.cardColor,
                radius: SabancimTheme.Shadow.cardRadius, y: SabancimTheme.Shadow.cardY)
    }
}

#Preview {
    VStack(spacing: 10) {
        SabancimNotificationRow(icon: "car.fill", iconColor: .blue,
                                title: "Poliçe Yenileme", message: "Kasko poliçenizin bitişine 15 gün kaldı.",
                                time: "2 saat önce", isUnread: true)
        SabancimNotificationRow(icon: "checkmark.seal.fill", iconColor: .green,
                                title: "Ödeme Başarılı", message: "AgeSA BES katkı payınız alındı.",
                                time: "Dün")
    }
    .padding()
    .background(Color(.secondarySystemBackground))
}

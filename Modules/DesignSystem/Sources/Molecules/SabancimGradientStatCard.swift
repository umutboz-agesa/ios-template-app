import SwiftUI

/// Gradyan istatistik kartı — etiket + alt başlık + büyük sayı + kısa liste + köşe ikonu.
/// Ana sayfa "Sigortalarım / Sağlığım" özet kartları için. DS molecule: düz parametre.
public struct SabancimGradientStatCard: View {
    private let badge: String
    private let subtitle: String
    private let stat: String
    private let caption: String
    private let icon: String
    private let gradient: LinearGradient
    private let onTap: (() -> Void)?

    public init(
        badge: String,
        subtitle: String,
        stat: String,
        caption: String,
        icon: String,
        gradient: LinearGradient,
        onTap: (() -> Void)? = nil
    ) {
        self.badge = badge
        self.subtitle = subtitle
        self.stat = stat
        self.caption = caption
        self.icon = icon
        self.gradient = gradient
        self.onTap = onTap
    }

    public var body: some View {
        if let onTap {
            Button(action: onTap) { card }.buttonStyle(.plain)
        } else {
            card
        }
    }

    private var card: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: SabancimTheme.Spacing.sm) {
                HStack(alignment: .top) {
                    Text(badge)
                        .font(.caption.weight(.bold))
                        .tracking(1)
                        .foregroundStyle(.white.opacity(0.85))
                    Spacer()
                    if onTap != nil {
                        Image(systemName: "chevron.right")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
                Text(subtitle)
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.95))

                Spacer(minLength: SabancimTheme.Spacing.md)

                Text(stat)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                Text(caption)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .padding(.trailing, 64)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            ZStack {
                Circle().fill(.white.opacity(0.18))
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 64, height: 64)
        }
        .padding(SabancimTheme.Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(gradient)
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.tile, style: .continuous))
    }
}

import SwiftUI

/// Kampanya promo banner'ı — markaya özel gradyan kart + rozet + başlık/alt metin + CTA
/// + dekoratif görsel. Slider içindeki her marka (AGESA/MEDISA/AKSIGORTA/Kampanya) kendi
/// `gradient` + `accent` rengini geçirir; component düz parametre alır (DS kuralı: model yok).
public struct SabancimPromoBanner: View {
    private let badge: String?
    private let title: String
    private let subtitle: String
    private let ctaTitle: String
    private let gradient: LinearGradient
    private let accent: Color
    private let imageName: String?
    private let onCTA: () -> Void

    public init(
        badge: String? = nil,
        title: String,
        subtitle: String,
        ctaTitle: String,
        gradient: LinearGradient,
        accent: Color = SabancimTheme.Colors.primary,
        imageName: String? = nil,
        onCTA: @escaping () -> Void
    ) {
        self.badge = badge
        self.title = title
        self.subtitle = subtitle
        self.ctaTitle = ctaTitle
        self.gradient = gradient
        self.accent = accent
        self.imageName = imageName
        self.onCTA = onCTA
    }

    public var body: some View {
        ZStack(alignment: .trailing) {
            decoration
            content
        }
        .padding(.horizontal, SabancimTheme.Spacing.lg)
        .padding(.vertical, SabancimTheme.Spacing.md)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(gradient)
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.tile, style: .continuous))
    }

    // MARK: - Metin + CTA
    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let badge {
                Text(badge)
                    .font(.caption2.weight(.bold))
                    .textCase(.uppercase)
                    .tracking(0.5)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.22))
                    .clipShape(Capsule())
            }
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            cta.padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing, imageName != nil ? 116 : 44)
    }

    /// Markaya özel beyaz CTA (gradyan üstünde), yazı rengi slider aksanı.
    private var cta: some View {
        Button(action: onCTA) {
            Text(ctaTitle)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, SabancimTheme.Spacing.md)
                .padding(.vertical, SabancimTheme.Spacing.sm + 2)
                .background(.white)
                .foregroundStyle(accent)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Dekor: 3D hediye (varsa) yoksa soluk gift silüeti
    @ViewBuilder private var decoration: some View {
        if let imageName {
            GiftShine(assetName: imageName, width: 122, height: 122)
                .offset(x: 14)
        } else {
            Image(systemName: "gift.fill")
                .font(.system(size: 150))
                .foregroundStyle(.white.opacity(0.14))
                .offset(x: 34)
                .allowsHitTesting(false)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        SabancimPromoBanner(
            badge: "AGESA",
            title: "Emeklilikte\nYanınızdayız",
            subtitle: "Geleceğini bugünden planla.",
            ctaTitle: "BES Satın Al",
            gradient: LinearGradient(colors: [Color(red: 0.09, green: 0.36, blue: 0.85), Color(red: 0.20, green: 0.55, blue: 0.98)], startPoint: .topLeading, endPoint: .bottomTrailing),
            accent: Color(red: 0.12, green: 0.40, blue: 0.90),
            onCTA: {}
        )
        SabancimPromoBanner(
            title: "Size özel Kampanyalar",
            subtitle: "Kaçırılmayacak fırsatlar sizi bekliyor!",
            ctaTitle: "Hemen Keşfet",
            gradient: SabancimTheme.Gradients.promo,
            imageName: "CampaignGift",
            onCTA: {}
        )
    }
    .padding()
}


/// Promo görseline sayfa açılışında "şık" animasyon: pop-in + parlama süpürmesi + yumuşak hale.
/// Parlama, görselin alpha şekline maskeli olduğu için sadece paketin üstünde gezer.
private struct GiftShine: View {
    let assetName: String
    let width: CGFloat
    let height: CGFloat

    @State private var appeared = false
    @State private var shineX: CGFloat = -1.0

    private var image: some View {
        Image(assetName, bundle: .main)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
    }

    var body: some View {
        image
            .background(
                Circle()
                    .fill(Color.white.opacity(0.22))
                    .frame(width: width * 0.85, height: width * 0.85)
                    .blur(radius: 26)
                    .opacity(appeared ? 1 : 0)
            )
            .overlay(
                LinearGradient(
                    colors: [.clear, .white.opacity(0.75), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: width * 0.45)
                .rotationEffect(.degrees(24))
                .offset(x: shineX * width)
                .blendMode(.screen)
                .mask(image)
            )
            .scaleEffect(appeared ? 1.0 : 0.82)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
                    appeared = true
                }
                withAnimation(.easeInOut(duration: 2.4).delay(0.35).repeatForever(autoreverses: false)) {
                    shineX = 1.6
                }
            }
    }
}

import SwiftUI

/// Ürün kartı — **molecule** (atom'ların birleşimi).
///
/// DesignSystem hiçbir iç modüle bağlı olmadığı için domain modeli (`Product`) DEĞİL,
/// **düz parametre** alır. Feature kendi modelini bu parametrelere map'ler:
/// `SabancimProductCard(title: p.title, subtitle: p.subtitle, imageURL: p.imageURL) { ... }`
public struct SabancimProductCard: View {
    private let title: String
    private let subtitle: String
    private let imageURL: URL?
    private let onTap: () -> Void

    public init(
        title: String,
        subtitle: String,
        imageURL: URL? = nil,
        onTap: @escaping () -> Void = {}
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: SabancimTheme.Spacing.md) {
                SabancimAsyncImage(url: imageURL)
                    .frame(width: 56, height: 56)
                VStack(alignment: .leading, spacing: SabancimTheme.Spacing.xs) {
                    Text(title).font(.headline).foregroundStyle(SabancimTheme.Colors.onSurface)
                    Text(subtitle).font(.subheadline).foregroundStyle(SabancimTheme.Colors.muted)
                }
                Spacer()
            }
            .padding(SabancimTheme.Spacing.md)
            .background(SabancimTheme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.card))
        }
        .buttonStyle(.plain)
    }
}

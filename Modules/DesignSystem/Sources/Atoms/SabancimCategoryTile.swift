import SwiftUI

/// Kategori kısayolu (Sağlığım/Arabam/Birikimlerim/Kampanyalar).
/// Dairesel tonlu ikon + altında etiket. `tint` ile renk ayrışması yapılabilir.
public struct SabancimCategoryTile: View {
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
            VStack(spacing: SabancimTheme.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.12))
                        .frame(width: 56, height: 56)
                    Image(systemName: systemName)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(tint)
                }
                Text(title)
                    .font(SabancimTheme.Typography.tileLabel)
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 16) {
        SabancimCategoryTile(systemName: "heart.fill", title: "Sağlığım") {}
        SabancimCategoryTile(systemName: "car.fill", title: "Arabam") {}
        SabancimCategoryTile(systemName: "banknote.fill", title: "Birikimlerim") {}
        SabancimCategoryTile(systemName: "gift.fill", title: "Kampanyalar") {}
    }
    .padding()
}

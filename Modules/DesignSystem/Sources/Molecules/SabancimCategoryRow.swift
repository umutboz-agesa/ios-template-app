import SwiftUI

/// Kategori satırı item modeli — DS'e ait hafif değer tipi (domain değil).
public struct SabancimCategoryItem: Identifiable {
    public let id = UUID()
    public let systemName: String
    public let title: String
    public let tint: Color
    public let action: () -> Void

    public init(systemName: String, title: String,
                tint: Color = SabancimTheme.Colors.primary, action: @escaping () -> Void) {
        self.systemName = systemName
        self.title = title
        self.tint = tint
        self.action = action
    }
}

/// Kategori kısayolları satırı (Sağlığım/Arabam/Birikimlerim/Kampanyalar).
/// SabancimCategoryTile'ları eşit genişlikte dizer.
public struct SabancimCategoryRow: View {
    private let items: [SabancimCategoryItem]

    public init(items: [SabancimCategoryItem]) {
        self.items = items
    }

    public var body: some View {
        HStack(alignment: .top, spacing: SabancimTheme.Spacing.sm) {
            ForEach(items) { item in
                SabancimCategoryTile(systemName: item.systemName, title: item.title,
                                  tint: item.tint, action: item.action)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    SabancimCategoryRow(items: [
        .init(systemName: "heart.fill", title: "Sağlığım") {},
        .init(systemName: "car.fill", title: "Arabam") {},
        .init(systemName: "banknote.fill", title: "Birikimlerim") {},
        .init(systemName: "gift.fill", title: "Kampanyalar") {},
    ])
    .padding()
}

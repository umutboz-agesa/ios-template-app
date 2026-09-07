import SwiftUI

/// Sözleşme özeti dashboard kartı — toplam adet + kategori tile'ları (ikon + adet + etiket).
/// DS molecule: düz parametre (model bilmez). Ana sayfada "Sözleşmelerim" özeti için.
public struct SabancimContractsSummaryCard: View {
    public struct Item: Identifiable {
        public let id = UUID()
        public let title: String
        public let count: Int
        public let color: Color
        public let icon: String
        public init(title: String, count: Int, color: Color, icon: String) {
            self.title = title
            self.count = count
            self.color = color
            self.icon = icon
        }
    }

    private let title: String
    private let total: Int
    private let totalCaption: String
    private let items: [Item]
    private let onTap: () -> Void

    public init(
        title: String,
        total: Int,
        totalCaption: String = "Aktif Sözleşme",
        items: [Item],
        onTap: @escaping () -> Void = {}
    ) {
        self.title = title
        self.total = total
        self.totalCaption = totalCaption
        self.items = items
        self.onTap = onTap
    }

    private let columns = [GridItem(.flexible(), alignment: .leading),
                           GridItem(.flexible(), alignment: .leading)]

    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: SabancimTheme.Spacing.sm) {
                HStack {
                    Text(title)
                        .font(SabancimTheme.Typography.cardTitle)
                        .foregroundStyle(SabancimTheme.Colors.onSurface)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote.bold())
                        .foregroundStyle(SabancimTheme.Colors.muted)
                }

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(total)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(SabancimTheme.Colors.onSurface)
                    Text(totalCaption)
                        .font(.subheadline)
                        .foregroundStyle(SabancimTheme.Colors.muted)
                }

                Divider()

                LazyVGrid(columns: columns, spacing: SabancimTheme.Spacing.sm) {
                    ForEach(items) { item in
                        HStack(spacing: SabancimTheme.Spacing.sm) {
                            Image(systemName: item.icon)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(item.color)
                                .frame(width: 30, height: 30)
                                .background(item.color.opacity(0.15))
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(item.count)")
                                    .font(.title3.bold())
                                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                                Text(item.title)
                                    .font(.caption)
                                    .foregroundStyle(SabancimTheme.Colors.muted)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                }
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
    SabancimContractsSummaryCard(
        title: "Sözleşmelerim",
        total: 5,
        items: [
            .init(title: "BES", count: 2, color: SabancimTheme.Brand.blue, icon: "banknote.fill"),
            .init(title: "Hayat", count: 1, color: SabancimTheme.Brand.orange, icon: "heart.fill"),
            .init(title: "Sağlık", count: 1, color: SabancimTheme.Brand.green, icon: "cross.case.fill"),
            .init(title: "Sigorta", count: 1, color: SabancimTheme.Brand.red, icon: "shield.lefthalf.filled"),
        ]
    )
    .padding()
    .background(Color(.secondarySystemBackground))
}

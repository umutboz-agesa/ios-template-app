import SwiftUI

/// Birikim özet kartı — donut + toplam + 2x2 kırılım legend'i ("Birikimlerimin Özeti").
/// DS molecule: düz `Slice` listesi alır. Hem Birikimlerim ekranı hem ana sayfa kullanır.
public struct SabancimSavingsOverviewCard: View {
    public struct Slice: Identifiable {
        public let id = UUID()
        public let label: String
        public let value: Decimal
        public let color: Color
        public init(label: String, value: Decimal, color: Color) {
            self.label = label
            self.value = value
            self.color = color
        }
    }

    private let title: String
    private let totalCaption: String
    private let total: Decimal
    private let slices: [Slice]
    private let onTap: (() -> Void)?
    private let fillHeight: Bool
    private let activeCount: Int?

    public init(
        title: String = "Birikimlerimin Özeti",
        totalCaption: String = "Toplam Birikimim",
        total: Decimal,
        slices: [Slice],
        onTap: (() -> Void)? = nil,
        fillHeight: Bool = false,
        activeCount: Int? = nil
    ) {
        self.title = title
        self.totalCaption = totalCaption
        self.total = total
        self.slices = slices
        self.onTap = onTap
        self.fillHeight = fillHeight
        self.activeCount = activeCount
    }

    /// Legend'i iki kolona böler: çift index sol, tek index sağ (grid satır sırasıyla aynı).
    private var evenSlices: [Slice] { slices.enumerated().filter { $0.offset % 2 == 0 }.map(\.element) }
    private var oddSlices: [Slice] { slices.enumerated().filter { $0.offset % 2 == 1 }.map(\.element) }

    private func legendColumn(_ items: [Slice]) -> some View {
        VStack(alignment: .leading, spacing: SabancimTheme.Spacing.sm) {
            ForEach(items) { legendItem($0) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func legendItem(_ slice: Slice) -> some View {
        HStack(alignment: .top, spacing: SabancimTheme.Spacing.sm) {
            Circle().fill(slice.color).frame(width: 9, height: 9).padding(.top, 4)
            VStack(alignment: .leading, spacing: 1) {
                Text(slice.label)
                    .font(.caption)
                    .foregroundStyle(SabancimTheme.Colors.muted)
                Text(SabancimFormat.currencyTRY(slice.value))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
            }
        }
    }

    public var body: some View {
        if let onTap {
            Button(action: onTap) { card }.buttonStyle(.plain)
        } else {
            card
        }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: SabancimTheme.Spacing.sm) {
            HStack(spacing: SabancimTheme.Spacing.sm) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: SabancimTheme.Spacing.sm)
                if let activeCount, activeCount > 0 {
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.footnote)
                            .foregroundStyle(SabancimTheme.Colors.success)
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("Aktif")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(SabancimTheme.Colors.muted)
                            Text("\(activeCount)")
                                .font(.subheadline.bold())
                                .foregroundStyle(SabancimTheme.Colors.success)
                            Text("sözleşme")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(SabancimTheme.Colors.muted)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(SabancimTheme.Colors.success.opacity(0.12))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(SabancimTheme.Colors.success.opacity(0.28), lineWidth: 1))
                    .fixedSize()
                    .layoutPriority(1)
                }
                if onTap != nil {
                    Image(systemName: "chevron.right")
                        .font(.footnote.bold())
                        .foregroundStyle(SabancimTheme.Colors.muted)
                }
            }

            HStack(spacing: SabancimTheme.Spacing.lg) {
                SabancimDonutChart(segments: slices.map {
                    .init(value: NSDecimalNumber(decimal: $0.value).doubleValue, color: $0.color)
                }, ringWidth: 18)
                .frame(width: 90, height: 90)

                VStack(alignment: .leading, spacing: 2) {
                    Text(SabancimFormat.currencyTRY(total))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(SabancimTheme.Colors.onSurface)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                    Text(totalCaption)
                        .font(.footnote)
                        .foregroundStyle(SabancimTheme.Colors.muted)
                }
                Spacer(minLength: 0)
            }

            Divider()

            HStack(alignment: .top, spacing: SabancimTheme.Spacing.md) {
                legendColumn(evenSlices)
                if slices.count > 1 {
                    Divider()
                }
                legendColumn(oddSlices)
            }
        }
        .padding(SabancimTheme.Spacing.md)
        .frame(maxWidth: .infinity, maxHeight: fillHeight ? .infinity : nil, alignment: .topLeading)
        .contentShape(Rectangle())
        .background(SabancimTheme.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.tile, style: .continuous))
        .shadow(color: SabancimTheme.Shadow.cardColor,
                radius: SabancimTheme.Shadow.cardRadius, y: SabancimTheme.Shadow.cardY)
    }
}

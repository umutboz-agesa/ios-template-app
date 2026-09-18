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
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            ForEach(items) { legendItem($0) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func legendItem(_ slice: Slice) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Circle().fill(slice.color).frame(width: 9, height: 9).padding(.top, 4)
            VStack(alignment: .leading, spacing: 1) {
                Text(slice.label)
                    .font(.caption)
                    .foregroundStyle(AppTheme.Colors.muted)
                Text(AppFormat.currencyTRY(slice.value))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.onSurface)
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
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: AppTheme.Spacing.sm)
                if let activeCount, activeCount > 0 {
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.Colors.success)
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("Aktif")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AppTheme.Colors.muted)
                            Text("\(activeCount)")
                                .font(.subheadline.bold())
                                .foregroundStyle(AppTheme.Colors.success)
                            Text("sözleşme")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AppTheme.Colors.muted)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.Colors.success.opacity(0.12))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(AppTheme.Colors.success.opacity(0.28), lineWidth: 1))
                    .fixedSize()
                    .layoutPriority(1)
                }
                if onTap != nil {
                    Image(systemName: "chevron.right")
                        .font(.footnote.bold())
                        .foregroundStyle(AppTheme.Colors.muted)
                }
            }

            HStack(spacing: AppTheme.Spacing.lg) {
                SabancimDonutChart(segments: slices.map {
                    .init(value: NSDecimalNumber(decimal: $0.value).doubleValue, color: $0.color)
                }, ringWidth: 18)
                .frame(width: 90, height: 90)

                VStack(alignment: .leading, spacing: 2) {
                    Text(AppFormat.currencyTRY(total))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.Colors.onSurface)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                    Text(totalCaption)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.Colors.muted)
                }
                Spacer(minLength: 0)
            }

            Divider()

            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                legendColumn(evenSlices)
                if slices.count > 1 {
                    Divider()
                }
                legendColumn(oddSlices)
            }
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, maxHeight: fillHeight ? .infinity : nil, alignment: .topLeading)
        .contentShape(Rectangle())
        .background(AppTheme.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.tile, style: .continuous))
        .shadow(color: AppTheme.Shadow.cardColor,
                radius: AppTheme.Shadow.cardRadius, y: AppTheme.Shadow.cardY)
    }
}

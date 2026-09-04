import SwiftUI

/// Birikim özet kartı — mockup'taki "Birikimlerim" kartı.
/// Tamamen atomlardan kurulur: SabancimCard + AmountText + TrendBadge + CircularProgress + LinkButton.
public struct SabancimSummaryCard: View {
    private let title: String
    private let amountCaption: String
    private let amount: Decimal
    private let trendPercent: Double
    private let trendSuffix: String?
    private let progress: Double
    private let progressCaption: String?
    private let detailTitle: String
    private let onDetails: () -> Void

    public init(
        title: String,
        amountCaption: String,
        amount: Decimal,
        trendPercent: Double,
        trendSuffix: String? = nil,
        progress: Double,
        progressCaption: String? = nil,
        detailTitle: String = "Detayları Gör",
        onDetails: @escaping () -> Void
    ) {
        self.title = title
        self.amountCaption = amountCaption
        self.amount = amount
        self.trendPercent = trendPercent
        self.trendSuffix = trendSuffix
        self.progress = progress
        self.progressCaption = progressCaption
        self.detailTitle = detailTitle
        self.onDetails = onDetails
    }

    public var body: some View {
        SabancimCard {
            VStack(alignment: .leading, spacing: SabancimTheme.Spacing.md) {
                Button(action: onDetails) {
                    HStack {
                        Text(title).font(SabancimTheme.Typography.cardTitle)
                            .foregroundStyle(SabancimTheme.Colors.onSurface)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote.bold())
                            .foregroundStyle(SabancimTheme.Colors.muted)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                HStack(alignment: .center, spacing: SabancimTheme.Spacing.md) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(amountCaption)
                            .font(SabancimTheme.Typography.caption)
                            .foregroundStyle(SabancimTheme.Colors.muted)
                        SabancimAmountText(amount)
                        SabancimTrendBadge(percent: trendPercent, suffix: trendSuffix)
                    }
                    Spacer()
                    SabancimCircularProgress(progress: progress, caption: progressCaption)
                        .frame(width: 92, height: 92)
                }

                SabancimLinkButton(detailTitle, action: onDetails)
            }
        }
    }
}

#Preview {
    SabancimSummaryCard(
        title: "Birikimlerim",
        amountCaption: "Toplam Birikim",
        amount: 125_750,
        trendPercent: 12.4,
        trendSuffix: "bu aya göre artış",
        progress: 0.68,
        progressCaption: "HEDEFİNİZE\nULAŞTINIZ",
        onDetails: {}
    )
    .padding()
    .background(Color(.secondarySystemBackground))
}

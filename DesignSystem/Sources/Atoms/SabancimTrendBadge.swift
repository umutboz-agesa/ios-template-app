import SwiftUI

/// Trend rozeti (↑ %12,4). İşaretli yüzde: pozitif → yeşil/yukarı, negatif → kırmızı/aşağı.
/// Opsiyonel açıklama eki ("bu aya göre artış") ikincil renkte gösterilir.
public struct SabancimTrendBadge: View {
    private let percent: Double
    private let suffix: String?

    public init(percent: Double, suffix: String? = nil) {
        self.percent = percent
        self.suffix = suffix
    }

    private var isUp: Bool { percent >= 0 }

    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isUp ? "arrow.up" : "arrow.down")
                .font(.caption2.bold())
            Text(SabancimFormat.percent(abs(percent)))
                .font(.caption.bold())
            if let suffix {
                Text(suffix)
                    .font(SabancimTheme.Typography.caption)
                    .foregroundStyle(SabancimTheme.Colors.muted)
            }
        }
        .foregroundStyle(isUp ? SabancimTheme.Colors.success : SabancimTheme.Colors.error)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8) {
        SabancimTrendBadge(percent: 12.4, suffix: "bu aya göre artış")
        SabancimTrendBadge(percent: -3.1, suffix: "bu aya göre azalış")
    }
    .padding()
}

import SwiftUI

/// Nazik segmented control — açık track, seçili segment beyaz pill (yumuşak gölge) + vurgu rengi.
/// Opsiyonel ikonlar (label yanında). Alçak/kompakt yükseklik. DS atom: düz parametre + binding.
public struct SabancimSegmentedControl: View {
    private let titles: [String]
    private let icons: [String]?
    @Binding private var selection: Int

    public init(_ titles: [String], icons: [String]? = nil, selection: Binding<Int>) {
        self.titles = titles
        self.icons = icons
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: 3) {
            ForEach(titles.indices, id: \.self) { i in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { selection = i }
                } label: {
                    HStack(spacing: 5) {
                        if let icons, i < icons.count {
                            Image(systemName: icons[i])
                                .font(.system(size: 12, weight: .semibold))
                        }
                        Text(titles[i])
                            .font(.footnote.weight(.semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, SabancimTheme.Spacing.sm - 1)
                    .foregroundStyle(i == selection ? SabancimTheme.Colors.primary : SabancimTheme.Colors.muted)
                    .background(
                        Capsule()
                            .fill(i == selection ? SabancimTheme.Colors.cardSurface : Color.clear)
                            .shadow(color: i == selection ? .black.opacity(0.08) : .clear,
                                    radius: 3, y: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(SabancimTheme.Colors.surface)
        .clipShape(Capsule())
    }
}

#Preview {
    struct Demo: View {
        @State var a = 0
        @State var b = 0
        var body: some View {
            VStack(spacing: 16) {
                SabancimSegmentedControl(["Birikimlerim", "Sigortalarım", "Sağlığım"],
                                         icons: ["chart.line.uptrend.xyaxis", "shield", "heart"],
                                         selection: $a)
                SabancimSegmentedControl(["İletişim Bilgileri", "Adres Bilgilerim"], selection: $b)
            }
            .padding()
        }
    }
    return Demo()
}

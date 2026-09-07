import SwiftUI

/// Açılır-kapanır ürün satırı (disclosure). Beyaz pill başlık + ikon + dönen chevron;
/// açıldığında alt kalemler (`SabancimProductSubRow`) animasyonla belirir.
/// DS molecule — düz parametre + `@ViewBuilder` içerik slotu (model bilmez).
public struct SabancimExpandableRow<Content: View>: View {
    private let icon: String
    private let iconColor: Color
    private let title: String
    private let content: Content
    @State private var expanded: Bool

    public init(
        icon: String,
        iconColor: Color = SabancimTheme.Colors.primary,
        title: String,
        initiallyExpanded: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self._expanded = State(initialValue: initiallyExpanded)
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.22)) { expanded.toggle() }
            } label: {
                HStack(spacing: SabancimTheme.Spacing.sm) {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(iconColor)
                        .frame(width: 24)
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(SabancimTheme.Colors.onSurface)
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(SabancimTheme.Colors.muted)
                        .rotationEffect(.degrees(expanded ? 180 : 0))
                }
                .padding(.horizontal, SabancimTheme.Spacing.md)
                .padding(.vertical, SabancimTheme.Spacing.sm + 4)
                .contentShape(Rectangle())   // tüm satır tıklanabilir (sadece ikon/ok değil)
            }
            .buttonStyle(.plain)

            if expanded {
                VStack(spacing: 0) { content }
                    .padding(.bottom, SabancimTheme.Spacing.xs)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(SabancimTheme.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.card, style: .continuous))
    }
}

/// Açılır satırın alt kalemi — sol başlık + sağ chevron. Üstünde ince ayraç.
public struct SabancimProductSubRow: View {
    private let title: String
    private let onTap: () -> Void

    public init(_ title: String, onTap: @escaping () -> Void = {}) {
        self.title = title
        self.onTap = onTap
    }

    public var body: some View {
        VStack(spacing: 0) {
            Divider().padding(.leading, SabancimTheme.Spacing.md)
            Button(action: onTap) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(SabancimTheme.Colors.onSurface.opacity(0.85))
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(SabancimTheme.Colors.tabInactive)
                }
                .padding(.horizontal, SabancimTheme.Spacing.md)
                .padding(.vertical, SabancimTheme.Spacing.sm + 2)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    SabancimExpandableRow(icon: "banknote.fill", title: "Bireysel Emeklilik (BES)", initiallyExpanded: true) {
        SabancimProductSubRow("BES Satın Al")
        SabancimProductSubRow("Fon Dağılımı Değişikliği")
        SabancimProductSubRow("Katkı Payı Artış Talebi")
    }
    .padding()
    .background(Color(red: 0.93, green: 0.95, blue: 1.0))
}

import SwiftUI

/// Sade detay navigasyon barı — solda geri butonu + başlık. Marka logosu/zil/profil YOK.
/// "Sözleşme Detayları" gibi alt ekranlarda kullanılır (SabancimAppBar'ın sade alternatifi).
public struct SabancimDetailBar: View {
    private let title: String
    private let onBack: () -> Void

    public init(title: String, onBack: @escaping () -> Void) {
        self.title = title
        self.onBack = onBack
    }

    public var body: some View {
        HStack(spacing: SabancimTheme.Spacing.md) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Geri")

            Text(title)
                .font(SabancimTheme.Typography.sectionTitle)
                .foregroundStyle(SabancimTheme.Colors.onSurface)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, SabancimTheme.Spacing.md)
        .padding(.vertical, SabancimTheme.Spacing.sm)
    }
}

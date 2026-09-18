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
        HStack(spacing: AppTheme.Spacing.md) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.onSurface)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Geri")

            Text(title)
                .font(AppTheme.Typography.sectionTitle)
                .foregroundStyle(AppTheme.Colors.onSurface)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
    }
}

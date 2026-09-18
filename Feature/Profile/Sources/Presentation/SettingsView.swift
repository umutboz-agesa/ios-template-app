import SwiftUI

/// `:feature:profile` — "Ayarlar" ekranı (Profilim > sağ üst dişli ile açılır).
/// Başlangıç sürümü: hesap, tercih (toggle'lar), uygulama ve çıkış. Fontlar DS standardında.
public struct SettingsView: BaseView {
    @Environment(\.dismiss) private var dismiss
    private let onRoute: (AppRoute) -> Void

    @State private var pushEnabled = true
    @State private var faceIDEnabled = false
    @AppStorage(ThemeStorage.key) private var appTheme: Theme = .dark

    public init(onRoute: @escaping (AppRoute) -> Void = { _ in }) {
        self.onRoute = onRoute
    }

    public var screenBody: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    section("Hesap") {
                        SabancimNavListRow(icon: "person.text.rectangle.fill", title: "Profil Bilgileri") { onRoute(.profile) }
                        SabancimNavListRow(icon: "lock.fill", title: "Şifre Değiştir")
                        SabancimNavListRow(icon: "lock.shield.fill", title: "Güvenlik Ayarları")
                        SabancimNavListRow(icon: "doc.text.fill", title: "Sözleşmelerim")
                    }
                    section("Tercihler") {
                        toggleRow(icon: "bell.fill", title: "Push Bildirimleri", isOn: $pushEnabled)
                        toggleRow(icon: "faceid", title: "Face ID ile Giriş", isOn: $faceIDEnabled)
                        SabancimNavListRow(icon: "bell.badge.fill", title: "Bildirim Tercihleri")
                    }
                    section("Uygulama") {
                        themeRow
                        SabancimNavListRow(icon: "globe", title: "Dil — Türkçe")
                        SabancimNavListRow(icon: "questionmark.circle.fill", title: "Yardım & Destek")
                        SabancimNavListRow(icon: "doc.text.fill", title: "Sözleşmeler & Aydınlatma Metni")
                    }
                    logoutButton
                }
                .padding(AppTheme.Spacing.md)
            }
        }
        .background { SabancimHeroBackground() }
    }

    // MARK: - Üst bar (geri + başlık)
    private var topBar: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.onSurface)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            Text("Ayarlar")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundStyle(AppTheme.Colors.onSurface)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
    }

    // MARK: - Parçalar
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.muted)
                .padding(.leading, 4)
            content()
        }
    }

    /// Tema seçimi — Menu picker; @AppStorage üzerinden runtime'da anında uygulanır.
    private var themeRow: some View {
        Menu {
            Picker("Tema", selection: $appTheme) {
                ForEach(Theme.allCases) { theme in
                    Text(theme.title).tag(theme)
                }
            }
        } label: {
            HStack(spacing: AppTheme.Spacing.sm + 4) {
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.primary)
                    .frame(width: 26)
                Text("Tema")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.onSurface)
                Spacer(minLength: 0)
                Text(appTheme.title)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.muted)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.tabInactive)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: AppTheme.Spacing.sm + 4) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.primary)
                .frame(width: 26)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.onSurface)
            Spacer(minLength: 0)
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(AppTheme.Colors.primary)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.md)
        .background(AppTheme.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
    }

    private var logoutButton: some View {
        Button {
            // Çıkış akışı ileride oturum yönetimine bağlanacak.
        } label: {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Çıkış Yap").font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(AppTheme.Colors.error)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.top, AppTheme.Spacing.sm)
    }
}

#Preview {
    SettingsView()
}

//
//  ProfileView.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 3.09.2026.
//
import SwiftUI
import Dependencies
import DesignSystem
import CorePresentation
import CoreNavigation

/// `:feature:profile` — "Profilim" ekranı.
/// Kullanıcı başlığı (isim TEK kaynaktan: currentUser) + İletişim/Adres segmentleri + güncelleme.
/// Sağ üstteki dişli → Ayarlar (settings giriş noktası).
public struct ProfileView: BaseView {
    @Environment(\.dismiss) private var dismiss
    @ObservationIgnored @Dependency(\.userSession) private var userSession
    @State private var segment = 0
    @State private var showLogoutConfirm = false
    @Environment(AppNavigator.self) private var navigator
    private let onRoute: (SabancimRoute) -> Void

    public init(onRoute: @escaping (SabancimRoute) -> Void = { _ in }) {
        self.onRoute = onRoute
    }

    /// Oturumu kapat + Login'e dön (RootView `logoutRequested`'i dinliyor).
    private func logout() {
        userSession.signOut()
        navigator.requestLogout()
    }

    // MARK: - Görüntülenen alanlar (gerçek session varsa oradan, yoksa demo)
    //
    // email/phone/identityNumber yalnızca gerçek login/OTP response'unda dolu gelir
    // (mock'ta nil). Dolu ise session'dan gösterilir; boş/nil ise aşağıdaki demo
    // sabitlerine düşülür. TCKN her durumda maskelenir.
    private enum Demo {
        static let customerNo = "10023456"
        static let email = "umut.boz@agesa.com.tr"
        static let phone = "+90 555 123 45 67"
        static let tckn = "123******01"
    }

    private func nonEmpty(_ value: String?) -> String? {
        guard let v = value?.trimmingCharacters(in: .whitespacesAndNewlines), !v.isEmpty
        else { return nil }
        return v
    }

    private var customerNo: String { nonEmpty(userSession.user?.customerId) ?? Demo.customerNo }
    private var email: String { nonEmpty(userSession.user?.email) ?? Demo.email }
    private var phone: String { nonEmpty(userSession.user?.phone) ?? Demo.phone }
    private var tckn: String {
        guard let id = nonEmpty(userSession.user?.identityNumber) else { return Demo.tckn }
        return Self.maskTCKN(id)
    }

    /// TCKN'yi ilk 3 + ortası yıldız + son 2 olacak şekilde maskeler (ör. 178******72).
    private static func maskTCKN(_ id: String) -> String {
        guard id.count > 5 else { return id }
        return "\(id.prefix(3))\(String(repeating: "*", count: id.count - 5))\(id.suffix(2))"
    }

    public var screenBody: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: SabancimTheme.Spacing.md) {
                    userHeader
                    SabancimSegmentedControl(["İletişim Bilgileri", "Adres Bilgilerim"], selection: $segment)
                    if segment == 0 { contactCard } else { addressCard }
                    SabancimButton("Bilgilerimi Güncelle", systemImage: "pencil") { }
                    Text("Son güncelleme: 20.07.2026")
                        .font(.caption)
                        .foregroundStyle(SabancimTheme.Colors.muted)
                        .frame(maxWidth: .infinity, alignment: .center)

                    applicationsSection
                }
                .padding(SabancimTheme.Spacing.md)
            }
        }
        .background { SabancimHeroBackground() }
        .alert("Çıkış", isPresented: $showLogoutConfirm) {
            Button("Vazgeç", role: .cancel) { }
            Button("Evet", role: .destructive) { logout() }
        } message: {
            Text("Uygulamadan çıkmak istediğinize emin misiniz?")
        }
    }

    // MARK: - Üst bar (geri + başlık + ayarlar dişli)
    private var topBar: some View {
        HStack(spacing: SabancimTheme.Spacing.md) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            Text("Profilim")
                .font(SabancimTheme.Typography.sectionTitle)
                .foregroundStyle(SabancimTheme.Colors.onSurface)
            Spacer(minLength: 0)
            Button { showLogoutConfirm = true } label: {
                HStack(spacing: 6) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Çıkış")
                        .font(.subheadline.weight(.semibold))
                }
                .foregroundStyle(SabancimTheme.Brand.red)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(SabancimTheme.Brand.red.opacity(0.08))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(SabancimTheme.Brand.red.opacity(0.5), lineWidth: 1.2))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Çıkış Yap")
            Button { onRoute(.settings) } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                    .frame(width: 38, height: 38)
                    .background(SabancimTheme.Colors.cardSurface)
                    .clipShape(Circle())
                    .shadow(color: SabancimTheme.Shadow.cardColor,
                            radius: SabancimTheme.Shadow.cardRadius, y: SabancimTheme.Shadow.cardY)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Ayarlar")
        }
        .padding(.horizontal, SabancimTheme.Spacing.md)
        .padding(.vertical, SabancimTheme.Spacing.sm)
    }

    // MARK: - Başvurularım
    private struct AppItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let status: String
        let statusColor: Color
        let icon: String
    }

    private let applications: [AppItem] = [
        .init(title: "Bireysel Emeklilik (BES)", subtitle: "Kendim • 27.07.2026",
              status: "İnceleniyor", statusColor: SabancimTheme.Colors.notification, icon: "banknote.fill"),
        .init(title: "Tamamlayıcı Sağlık Sigortası", subtitle: "12.05.2026",
              status: "Onaylandı", statusColor: SabancimTheme.Colors.success, icon: "cross.case.fill"),
        .init(title: "Kasko Sigortası", subtitle: "02.01.2026",
              status: "Onaylandı", statusColor: SabancimTheme.Colors.success, icon: "shield.lefthalf.filled"),
    ]

    private var applicationsSection: some View {
        VStack(alignment: .leading, spacing: SabancimTheme.Spacing.sm) {
            Text("Başvurularım")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(SabancimTheme.Colors.muted)
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(applications) { app in
                applicationRow(app)
            }
        }
        .padding(.top, SabancimTheme.Spacing.sm)
    }

    private func applicationRow(_ app: AppItem) -> some View {
        HStack(spacing: SabancimTheme.Spacing.md) {
            Image(systemName: app.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(SabancimTheme.Colors.primary)
                .frame(width: 38, height: 38)
                .background(SabancimTheme.Colors.primary.opacity(0.12))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(app.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                Text(app.subtitle)
                    .font(.caption)
                    .foregroundStyle(SabancimTheme.Colors.muted)
            }
            Spacer(minLength: 0)
            Text(app.status)
                .font(.caption2.weight(.bold))
                .foregroundStyle(app.statusColor)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(app.statusColor.opacity(0.14))
                .clipShape(Capsule())
        }
        .padding(SabancimTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SabancimTheme.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.card, style: .continuous))
        .shadow(color: SabancimTheme.Shadow.cardColor,
                radius: SabancimTheme.Shadow.cardRadius, y: SabancimTheme.Shadow.cardY)
    }

    // MARK: - Kullanıcı başlığı
    private var userHeader: some View {
        VStack(spacing: SabancimTheme.Spacing.sm) {
            ProfileAvatarButton(size: 88)
            Text(userSession.profile.fullName)
                .font(.title3.bold())
                .foregroundStyle(SabancimTheme.Colors.onSurface)
            Text("Müşteri No: \(customerNo)")
                .font(.footnote)
                .foregroundStyle(SabancimTheme.Colors.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, SabancimTheme.Spacing.sm)
    }

    // MARK: - İletişim / Adres kartları
    private var contactCard: some View {
        infoCard {
            SabancimInfoRow(systemImage: "envelope.fill", label: "E-posta", value: email)
            Divider().padding(.leading, 42)
            SabancimInfoRow(systemImage: "phone.fill", label: "Telefon", value: phone)
            Divider().padding(.leading, 42)
            SabancimInfoRow(systemImage: "person.text.rectangle.fill", label: "T.C. Kimlik No", value: tckn)
        }
    }

    private var addressCard: some View {
        infoCard {
            SabancimInfoRow(systemImage: "house.fill", label: "Adres", value: "Levent Mah. Büyükdere Cad. No:1 D:5")
            Divider().padding(.leading, 42)
            SabancimInfoRow(systemImage: "map.fill", label: "İl / İlçe", value: "İstanbul / Beşiktaş")
            Divider().padding(.leading, 42)
            SabancimInfoRow(systemImage: "number", label: "Posta Kodu", value: "34394")
        }
    }

    private func infoCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) { content() }
            .padding(.horizontal, SabancimTheme.Spacing.md)
            .padding(.vertical, SabancimTheme.Spacing.xs)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(SabancimTheme.Colors.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.tile, style: .continuous))
            .shadow(color: SabancimTheme.Shadow.cardColor,
                    radius: SabancimTheme.Shadow.cardRadius, y: SabancimTheme.Shadow.cardY)
    }
}

#Preview {
    ProfileView().environment(AppNavigator())
}

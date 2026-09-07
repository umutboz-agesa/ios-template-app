import SwiftUI

/// Üst bar: solda marka/logo slot'u, sağda bildirim + profil ikon butonları.
/// Logo brand-neutral kalsın diye slot (ViewBuilder) olarak alınır.
public struct SabancimTopBar<Leading: View>: View {
    private let leading: Leading
    private let hasNotificationBadge: Bool
    private let onNotifications: (() -> Void)?
    private let onAssistant: (() -> Void)?
    private let onProfile: (() -> Void)?
    private let onBack: (() -> Void)?

    public init(
        hasNotificationBadge: Bool = false,
        onBack: (() -> Void)? = nil,
        onNotifications: (() -> Void)? = nil,
        onAssistant: (() -> Void)? = nil,
        onProfile: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading
    ) {
        self.hasNotificationBadge = hasNotificationBadge
        self.onBack = onBack
        self.onNotifications = onNotifications
        self.onAssistant = onAssistant
        self.onProfile = onProfile
        self.leading = leading()
    }

    public var body: some View {
        HStack(spacing: SabancimTheme.Spacing.sm) {
            if let onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(SabancimTheme.Colors.onSurface)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Geri")
            }
            leading
            Spacer(minLength: SabancimTheme.Spacing.md)
            if let onNotifications {
                SabancimIconButton(systemName: "bell", hasBadge: hasNotificationBadge, action: onNotifications)
            }
            if let onAssistant {
                Button(action: onAssistant) {
                    Image(systemName: "ellipsis.message.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(SabancimTheme.Colors.primary)
                        .frame(width: 38, height: 38)
                        .background(SabancimTheme.Colors.cardSurface)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(SabancimTheme.Colors.primary, lineWidth: 2))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Sabancım Asistan")
            }
            if let onProfile {
                SabancimIconButton(systemName: "person", action: onProfile)
            }
        }
    }
}

#Preview {
    SabancimTopBar(hasNotificationBadge: true, onNotifications: {}, onProfile: {}) {
        Text("SABANCIm").font(.title3.bold()).foregroundStyle(SabancimTheme.Colors.primary)
    }
    .padding()
}

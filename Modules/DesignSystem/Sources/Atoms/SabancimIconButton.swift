import SwiftUI

/// Üst bar ikon butonu (zil, profil). Opsiyonel kırmızı badge noktası (okunmamış).
public struct SabancimIconButton: View {
    private let systemName: String
    private let hasBadge: Bool
    private let action: () -> Void

    public init(systemName: String, hasBadge: Bool = false, action: @escaping () -> Void) {
        self.systemName = systemName
        self.hasBadge = hasBadge
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(SabancimTheme.Colors.onSurface)
                .frame(width: 40, height: 40)
                .overlay(alignment: .topTrailing) {
                    if hasBadge {
                        Circle()
                            .fill(SabancimTheme.Colors.notification)
                            .frame(width: 8, height: 8)
                            .offset(x: -8, y: 8)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 16) {
        SabancimIconButton(systemName: "bell", hasBadge: true) {}
        SabancimIconButton(systemName: "person") {}
    }
    .padding()
}

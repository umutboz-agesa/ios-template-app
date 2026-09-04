import SwiftUI

/// Bölüm başlığı ("Hızlı İşlemler") + opsiyonel sağ aksiyon ("Tümü ›").
public struct SabancimSectionHeader: View {
    private let title: String
    private let actionTitle: String?
    private let onAction: (() -> Void)?

    public init(title: String, actionTitle: String? = nil, onAction: (() -> Void)? = nil) {
        self.title = title
        self.actionTitle = actionTitle
        self.onAction = onAction
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(SabancimTheme.Typography.sectionTitle)
                .foregroundStyle(SabancimTheme.Colors.onSurface)
            Spacer()
            if let actionTitle, let onAction {
                SabancimLinkButton(actionTitle, action: onAction)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        SabancimSectionHeader(title: "Hızlı İşlemler", actionTitle: "Tümü") {}
        SabancimSectionHeader(title: "Birikimlerim")
    }
    .padding()
}

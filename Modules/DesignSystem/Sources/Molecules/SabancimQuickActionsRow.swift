import SwiftUI

/// Hızlı işlem satırı item modeli — DS'e ait hafif değer tipi (domain değil).
public struct SabancimQuickActionItem: Identifiable {
    public let id = UUID()
    public let systemName: String
    public let title: String
    public let tint: Color
    public let action: () -> Void

    public init(systemName: String,
                title: String,
                tint: Color = SabancimTheme.Colors.primary,
                action: @escaping () -> Void) {
        self.systemName = systemName
        self.title = title
        self.tint = tint
        self.action = action
    }
}

/// Hızlı işlem kartları satırı (Poliçelerim / Hasar İhbarı / Ödeme Yap).
/// Eşit genişlikte dizer; üstten hizalı (farklı satır sayılarında düzgün durur).
public struct SabancimQuickActionsRow: View {
    private let items: [SabancimQuickActionItem]

    public init(items: [SabancimQuickActionItem]) {
        self.items = items
    }

    public var body: some View {
        HStack(alignment: .top, spacing: SabancimTheme.Spacing.sm) {
            ForEach(items) { item in
                SabancimQuickActionChip(systemName: item.systemName, title: item.title,
                                        tint: item.tint, action: item.action)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    SabancimQuickActionsRow(items: [
        .init(systemName: "doc.text", title: "Poliçelerim / Sözleşmelerim") {},
        .init(systemName: "exclamationmark.triangle", title: "Hasar İhbarı", tint: SabancimTheme.Colors.notification) {},
        .init(systemName: "creditcard", title: "Ödeme Yap", tint: SabancimTheme.Colors.success) {},
    ])
    .padding()
    .background(Color(.secondarySystemBackground))
}

import SwiftUI

/// Metin + chevron link ("Detayları Gör ›", "Tümü ›"). Vurgu rengiyle.
public struct SabancimLinkButton: View {
    private let title: String
    private let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 2) {
                Text(title).font(.subheadline.weight(.semibold))
                Image(systemName: "chevron.right").font(.caption.bold())
            }
            .foregroundStyle(SabancimTheme.Colors.primary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        SabancimLinkButton("Detayları Gör") {}
        SabancimLinkButton("Tümü") {}
    }
    .padding()
}

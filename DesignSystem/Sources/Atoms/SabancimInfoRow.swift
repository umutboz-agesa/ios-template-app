import SwiftUI

/// Bilgi satırı — küçük etiket (üstte, muted) + değer (altta, koyu). Opsiyonel sol ikon.
/// Profil/detay kartlarında "E-posta / umut@..." gibi alanlar için. DS atom: düz parametre.
public struct SabancimInfoRow: View {
    private let systemImage: String?
    private let label: String
    private let value: String

    public init(systemImage: String? = nil, label: String, value: String) {
        self.systemImage = systemImage
        self.label = label
        self.value = value
    }

    public var body: some View {
        HStack(spacing: SabancimTheme.Spacing.md) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(SabancimTheme.Colors.primary)
                    .frame(width: 26)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(SabancimTheme.Colors.muted)
                Text(value)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(SabancimTheme.Colors.onSurface)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, SabancimTheme.Spacing.sm)
    }
}

#Preview {
    VStack(spacing: 0) {
        SabancimInfoRow(systemImage: "envelope.fill", label: "E-posta", value: "umut@example.com")
        Divider()
        SabancimInfoRow(systemImage: "phone.fill", label: "Telefon", value: "+90 555 123 45 67")
    }
    .padding()
}

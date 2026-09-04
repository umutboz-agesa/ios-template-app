import SwiftUI

/// Para tutarı metni (₺125.750,00). Ham `Decimal` alır, formatı SabancimFormat'tan üretir.
public struct SabancimAmountText: View {
    private let amount: Decimal
    private let font: Font
    private let color: Color

    public init(_ amount: Decimal,
                font: Font = SabancimTheme.Typography.amount,
                color: Color = SabancimTheme.Colors.onSurface) {
        self.amount = amount
        self.font = font
        self.color = color
    }

    public var body: some View {
        Text(SabancimFormat.currencyTRY(amount))
            .font(font)
            .foregroundStyle(color)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8) {
        SabancimAmountText(125_750)
        SabancimAmountText(1_250.5, font: .headline)
    }
    .padding()
}

//
//  SabancimCheckbox.swift
//  SabancimSuperApp
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import SwiftUI

/// Genel amaçlı checkbox. `SabancimTextField` ile aynı kural: model değil düz
/// parametre alır (`Binding<Bool>`) — hangi ekranda, ne için kullanıldığını bilmez.
public struct SabancimCheckbox: View {
    @Binding private var isChecked: Bool

    public init(isChecked: Binding<Bool>) {
        self._isChecked = isChecked
    }

    public var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundStyle(isChecked ? SabancimTheme.Colors.primary : SabancimTheme.Colors.muted)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SabancimCheckbox(isChecked: .constant(true))
    SabancimCheckbox(isChecked: .constant(false))
}

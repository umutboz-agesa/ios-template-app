//
//  SabancimLabeledCheckbox.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import SwiftUI

/// Atomic Design Molecule — `SabancimCheckbox` (Atom) + herhangi bir label içeriğini
/// birleştirir. Label'ın NE gösterdiğini (düz metin, link'li metin, ikon vb.) ya da
/// nasıl davrandığını (tap gesture, vs.) bilerek bilmiyor — bunlar tamamen çağırana
/// ait, Molecule sadece ikisini yan yana, doğru hizalamada bir araya getiriyor.
public struct SabancimLabeledCheckbox<Label: View>: View {
    @Binding private var isChecked: Bool
    private let label: Label

    public init(isChecked: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self._isChecked = isChecked
        self.label = label()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            SabancimCheckbox(isChecked: $isChecked)
            label
        }
    }
}

#Preview {
    SabancimLabeledCheckbox(isChecked: .constant(true)) {
        Text("Kullanıcı Sözleşmesi'ni kabul ediyorum")
    }
}

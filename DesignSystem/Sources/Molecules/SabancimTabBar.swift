import SwiftUI

/// Sabancım özel alt tab bar (redesign).
/// - Seçili sekme: mavi ikon+yazı + açık mavi zemin pill; ikon FILLED.
/// - Pasif sekme: mavi-gri ikon+yazı; ikon OUTLINE. Tüm ikonlar aynı boyut/ağırlık.
/// - Renkler spec paletinden; dark tema için ayrı varyant.
public struct SabancimTabBar: View {
    public struct Item: Identifiable {
        public let id: Int
        public let title: String
        public let outline: String
        public let filled: String
        public init(id: Int, title: String, outline: String, filled: String) {
            self.id = id; self.title = title; self.outline = outline; self.filled = filled
        }
    }

    @Binding private var selection: Int
    private let items: [Item]
    @Environment(\.colorScheme) private var scheme

    private let menuItemID: Int?
    private let menuActive: Bool
    private let onMenuTap: (() -> Void)?

    public init(selection: Binding<Int>,
                items: [Item] = SabancimTabBar.defaultItems,
                menuItemID: Int? = nil,
                menuActive: Bool = false,
                onMenuTap: (() -> Void)? = nil) {
        self._selection = selection
        self.items = items
        self.menuItemID = menuItemID
        self.menuActive = menuActive
        self.onMenuTap = onMenuTap
    }

    public static let defaultItems: [Item] = [
        .init(id: 0, title: "Sabancım", outline: "house",           filled: "house.fill"),
        .init(id: 1, title: "BES",       outline: "banknote",       filled: "banknote.fill"),
        .init(id: 2, title: "Sağlık",   outline: "heart",           filled: "heart.fill"),
        .init(id: 3, title: "Araba",    outline: "car",             filled: "car.fill"),
        .init(id: 4, title: "Keşfet",   outline: "safari",          filled: "safari.fill"),
    ]

    public var body: some View {
        let c = Palette(scheme)
        HStack(spacing: 0) {
            ForEach(items) { item in
                let isMenu = (item.id == menuItemID)
                let selected = isMenu ? menuActive : (selection == item.id && !menuActive)
                Button {
                    if isMenu { onMenuTap?() } else { selection = item.id }
                } label: { EmptyView() }
                .buttonStyle(TabItemStyle(item: item, selected: selected, c: c))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(c.surface)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(c.border, lineWidth: 1)
        )
        .shadow(color: c.shadow, radius: 14, y: 6)
        .padding(.horizontal, 12)
        .padding(.bottom, 4)
    }
}

/// Tek sekme — seçili/pressed durumuna göre renk + pill zemin.
private struct TabItemStyle: ButtonStyle {
    let item: SabancimTabBar.Item
    let selected: Bool
    let c: Palette

    func makeBody(configuration: Configuration) -> some View {
        let tint: Color = selected
            ? (configuration.isPressed ? c.pressed : c.selected)
            : c.inactiveIcon
        let textColor: Color = selected
            ? (configuration.isPressed ? c.pressed : c.selected)
            : c.inactiveText

        return VStack(spacing: 4) {
            ZStack {
                if selected {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(c.pill)
                        .frame(width: 56, height: 34)
                }
                Image(systemName: selected ? item.filled : item.outline)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(tint)
            }
            .frame(height: 34)
            Text(item.title)
                .font(.caption2.weight(selected ? .semibold : .regular))
                .foregroundStyle(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .animation(.easeInOut(duration: 0.15), value: selected)
    }
}

/// Tab bar renk paleti — spec hex'leri (light) + türetilmiş dark varyant.
private struct Palette {
    let surface, pill, selected, pressed, inactiveIcon, inactiveText, border, shadow: Color

    init(_ s: ColorScheme) {
        if s == .dark {
            surface      = Color(red: 0.063, green: 0.106, blue: 0.157)
            pill         = Color(red: 0.106, green: 0.239, blue: 0.376)
            selected     = Color(red: 0.310, green: 0.639, blue: 1.000)
            pressed      = Color(red: 0.216, green: 0.522, blue: 0.878)
            inactiveIcon = Color(red: 0.560, green: 0.616, blue: 0.694)
            inactiveText = Color(red: 0.682, green: 0.722, blue: 0.780)
            border       = Color(red: 0.157, green: 0.216, blue: 0.278)
            shadow       = Color.black.opacity(0.45)
        } else {
            surface      = Color(red: 0.973, green: 0.984, blue: 1.000)  // #F8FBFF
            pill         = Color(red: 0.890, green: 0.941, blue: 1.000)  // #E3F0FF
            selected     = Color(red: 0.000, green: 0.404, blue: 0.773)  // #0067C5
            pressed      = Color(red: 0.000, green: 0.310, blue: 0.620)  // #004F9E
            inactiveIcon = Color(red: 0.325, green: 0.380, blue: 0.455)  // #536174
            inactiveText = Color(red: 0.204, green: 0.251, blue: 0.329)  // #344054
            border       = Color(red: 0.851, green: 0.898, blue: 0.949)  // #D9E5F2
            shadow       = Color(red: 0.086, green: 0.227, blue: 0.373).opacity(0.10)  // #163A5F @10%
        }
    }
}

#Preview {
    struct Demo: View {
        @State var sel = 0
        var body: some View {
            VStack {
                Spacer()
                SabancimTabBar(selection: $sel)
            }
            .background(Color(red: 0.89, green: 0.93, blue: 1.0))
        }
    }
    return Demo()
}

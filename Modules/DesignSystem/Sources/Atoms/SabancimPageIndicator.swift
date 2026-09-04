import SwiftUI

/// Sayfa noktaları (carousel indicator). Aktif nokta kapsül şeklinde genişler.
public struct SabancimPageIndicator: View {
    private let count: Int
    private let index: Int

    public init(count: Int, index: Int) {
        self.count = count
        self.index = index
    }

    public var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<max(count, 0), id: \.self) { i in
                Capsule()
                    .fill(i == index ? SabancimTheme.Colors.primary : SabancimTheme.Colors.tabInactive)
                    .frame(width: i == index ? 18 : 6, height: 6)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: index)
    }
}

#Preview {
    SabancimPageIndicator(count: 3, index: 0).padding()
}

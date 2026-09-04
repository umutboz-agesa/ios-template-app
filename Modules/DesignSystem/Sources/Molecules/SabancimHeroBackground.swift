import SwiftUI

/// Uygulama geneli "halkalı" hero arka planı — üstte degrade + dekoratif halkalar,
/// altında nötr taban. Home, Sağlığım, Arabam vb. `.background { SabancimHeroBackground() }` kullanır.
/// Tema-duyarlı: açık temada lavanta, koyu temada koyu lacivert (runtime tema ile değişir).
///
/// `.background` içinde kullanılmak üzere: layout'u ETKİLEMEZ, dokunma almaz.
public struct SabancimHeroBackground: View {
    @Environment(\.colorScheme) private var scheme
    private let heroHeight: CGFloat

    public init(heroHeight: CGFloat = 430) {
        self.heroHeight = heroHeight
    }

    private var baseColor: Color {
        scheme == .dark
            ? Color(red: 0.07, green: 0.08, blue: 0.12)
            : Color(red: 0.93, green: 0.95, blue: 1.0)
    }

    public var body: some View {
        ZStack(alignment: .top) {
            baseColor
            HeroRings(scheme: scheme)
                .frame(height: heroHeight)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

/// Hero degrade + dekoratif halkalar (GeometryReader, oransal position → layout güvenli).
private struct HeroRings: View {
    let scheme: ColorScheme

    private var gradientColors: [Color] {
        scheme == .dark
            ? [Color(red: 0.10, green: 0.12, blue: 0.20), Color(red: 0.06, green: 0.08, blue: 0.14)]
            : [Color(red: 0.94, green: 0.96, blue: 1.00), Color(red: 0.86, green: 0.91, blue: 1.00)]
    }
    private var ringFill: Color {
        scheme == .dark ? Color.white.opacity(0.05) : Color.white.opacity(0.30)
    }
    private var ringTint: Color {
        scheme == .dark
            ? Color(red: 0.30, green: 0.42, blue: 0.85).opacity(0.20)
            : Color(red: 0.73, green: 0.84, blue: 1.0).opacity(0.33)
    }
    private var ringStroke: Color {
        scheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.32)
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle()
                    .fill(ringFill)
                    .frame(width: w * 0.95, height: w * 0.95)
                    .position(x: w * 1.02, y: h * 0.20)
                Circle()
                    .fill(ringTint)
                    .frame(width: w * 0.88, height: w * 0.88)
                    .position(x: w * 0.98, y: h * 0.24)
                Circle()
                    .stroke(ringStroke, lineWidth: 22)
                    .frame(width: w * 0.58, height: w * 0.58)
                    .position(x: w * 0.92, y: h * 0.17)
                Circle()
                    .stroke(ringStroke, lineWidth: 28)
                    .frame(width: w * 0.95, height: w * 0.95)
                    .position(x: w * 1.02, y: h * 0.58)
                Circle()
                    .fill(ringTint.opacity(0.3))
                    .frame(width: w * 1.05, height: w * 1.05)
                    .position(x: w * 1.10, y: h * 0.62)
            }
            .clipped()
        }
    }
}

#Preview {
    Text("İçerik")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { SabancimHeroBackground() }
}

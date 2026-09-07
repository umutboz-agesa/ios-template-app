import SwiftUI

/// Dairesel ilerleme halkası + merkez yüzde metni (mockup'taki %68 / HEDEFİNİZE ULAŞTINIZ).
/// Ekran her açıldığında (onAppear) 0'dan hedefe doğru animasyonla dolar; halka ve
/// ortadaki sayı birlikte sayar (Animatable deseni).
public struct SabancimCircularProgress: View {
    private let progress: Double
    private let lineWidth: CGFloat
    private let caption: String?

    @State private var animated: Double = 0

    public init(progress: Double, lineWidth: CGFloat = 10, caption: String? = nil) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.caption = caption
    }

    public var body: some View {
        Gauge(value: animated, lineWidth: lineWidth, caption: caption)
            .onAppear {
                animated = 0
                withAnimation(.easeOut(duration: 1.1)) {
                    animated = progress
                }
            }
    }

    /// Animatable alt görünüm — `value` animasyon boyunca ara değerlerle yeniden çizilir,
    /// böylece hem trim (halka) hem yüzde metni birlikte animasyon yapar.
    private struct Gauge: View, @MainActor Animatable {
        var value: Double
        var lineWidth: CGFloat
        var caption: String?

        var animatableData: Double {
            get { value }
            set { value = newValue }
        }

        var body: some View {
            ZStack {
                Circle()
                    .stroke(SabancimTheme.Colors.surface, lineWidth: lineWidth)
                Circle()
                    .trim(from: 0, to: max(0, min(value, 1)))
                    .stroke(SabancimTheme.Colors.primary,
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text(SabancimFormat.percent(value * 100, fractionDigits: 0))
                        .font(.headline.bold())
                        .foregroundStyle(SabancimTheme.Colors.primary)
                    if let caption {
                        Text(caption)
                            .font(.system(size: 9))
                            .foregroundStyle(SabancimTheme.Colors.muted)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(4)
            }
        }
    }
}

#Preview {
    SabancimCircularProgress(progress: 0.68, caption: "HEDEFİNİZE\nULAŞTINIZ")
        .frame(width: 96, height: 96)
        .padding()
}

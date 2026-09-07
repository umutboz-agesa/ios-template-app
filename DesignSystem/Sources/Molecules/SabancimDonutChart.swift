import SwiftUI

/// Çok segmentli donut (halka) grafik — birikim/portföy kırılımları için.
/// DS component: düz `Segment` listesi alır (değer + renk). Track tema-duyarlı.
public struct SabancimDonutChart: View {
    public struct Segment: Identifiable {
        public let id = UUID()
        public let value: Double
        public let color: Color
        public init(value: Double, color: Color) {
            self.value = value
            self.color = color
        }
    }

    private let segments: [Segment]
    private let ringWidth: CGFloat
    private let gap: Double
    private let animated: Bool
    @State private var sweep: Double = 0

    public init(segments: [Segment], ringWidth: CGFloat = 24, gap: Double = 0.006, animated: Bool = true) {
        self.segments = segments
        self.ringWidth = ringWidth
        self.gap = gap
        self.animated = animated
    }

    private var total: Double { max(segments.reduce(0) { $0 + $1.value }, 0.0001) }

    private var arcs: [(start: Double, end: Double, color: Color)] {
        var out: [(Double, Double, Color)] = []
        var acc = 0.0
        for s in segments {
            let f = s.value / total
            out.append((acc, acc + f, s.color))
            acc += f
        }
        return out
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(SabancimTheme.Colors.surface, lineWidth: ringWidth)
            ForEach(Array(arcs.enumerated()), id: \.offset) { _, arc in
                Circle()
                    .trim(from: arc.start + gap,
                          to: max(arc.start + gap, min(arc.end - gap, sweep)))
                    .stroke(arc.color, style: StrokeStyle(lineWidth: ringWidth, lineCap: .butt))
                    .rotationEffect(.degrees(-90))
            }
        }
        .padding(ringWidth / 2)
        .onAppear {
            guard animated else { sweep = 1; return }
            sweep = 0
            withAnimation(.easeOut(duration: 0.9)) { sweep = 1 }
        }
        // Veri async geldiğinde (boş → dolu) sweep'i yeniden akıt — ör. detayda `load()` sonrası.
        .onChange(of: segments.map(\.value)) {
            guard animated else { sweep = 1; return }
            sweep = 0
            withAnimation(.easeOut(duration: 0.9)) { sweep = 1 }
        }
    }
}

#Preview {
    SabancimDonutChart(segments: [
        .init(value: 52500, color: SabancimTheme.Brand.blue),
        .init(value: 13750, color: SabancimTheme.Brand.purple),
        .init(value: 44233, color: SabancimTheme.Colors.success),
        .init(value: 52500, color: SabancimTheme.Brand.indigo),
    ])
    .frame(width: 140, height: 140)
    .padding()
}

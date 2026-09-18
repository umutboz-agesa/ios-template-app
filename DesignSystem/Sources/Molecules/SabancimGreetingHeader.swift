import SwiftUI

public struct SabancimGreetingHeader: View {
    private let title: String
    private let subtitle: String?
    private let showsWave: Bool

    @State private var wave = false

    public init(title: String, subtitle: String? = nil, showsWave: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.showsWave = showsWave
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(title)
                    .font(AppTheme.Typography.greeting)
                    .foregroundStyle(AppTheme.Colors.onSurface)

                if showsWave {
                    Image(systemName: "hand.raised.fill")
                        .font(AppTheme.Typography.greeting)
                        .symbolRenderingMode(.monochrome)
                        .foregroundStyle(Color.yellow)
                        .rotationEffect(.degrees(wave ? 14 : -14), anchor: .bottom)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                                wave = true
                            }
                        }
                }
            }
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.muted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SabancimGreetingHeader(title: "Merhaba, Ayşe",
                           subtitle: "Bugün birlikte ne yapmak istersiniz?")
        .padding()
}

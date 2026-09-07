import SwiftUI

/// Saf durum görünümleri — **düz parametre** alır, `Loadable`/`SabancimError` bilmez.
/// `Loadable<T>` → görünüm tutkalı `CoreUI.LoadableView`'da; DesignSystem saf kalır.

public struct SabancimLoadingView: View {
    public init() {}
    public var body: some View {
        ProgressView()
            .tint(SabancimTheme.Colors.primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

public struct SabancimErrorView: View {
    private let message: String
    private let onRetry: (() -> Void)?

    public init(message: String, onRetry: (() -> Void)? = nil) {
        self.message = message
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: SabancimTheme.Spacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(SabancimTheme.Colors.error)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(SabancimTheme.Colors.muted)
            if let onRetry {
                SabancimButton("Tekrar dene", action: onRetry)
                    .fixedSize()
            }
        }
        .padding(SabancimTheme.Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

public struct SabancimEmptyStateView: View {
    private let text: String
    public init(text: String) { self.text = text }
    public var body: some View {
        Text(text)
            .foregroundStyle(SabancimTheme.Colors.muted)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

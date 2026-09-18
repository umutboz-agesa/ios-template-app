import SwiftUI

/// Saf durum görünümleri — **düz parametre** alır, `Loadable`/`AppError` bilmez.
/// `Loadable<T>` → görünüm tutkalı `CoreUI.LoadableView`'da; DesignSystem saf kalır.

public struct LoadingView: View {
    public init() {}
    public var body: some View {
        ProgressView()
            .tint(AppTheme.Colors.primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

public struct ErrorView: View {
    private let message: String
    private let onRetry: (() -> Void)?

    public init(message: String, onRetry: (() -> Void)? = nil) {
        self.message = message
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(AppTheme.Colors.error)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(AppTheme.Colors.muted)
            if let onRetry {
                SabancimButton("Tekrar dene", action: onRetry)
                    .fixedSize()
            }
        }
        .padding(AppTheme.Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

public struct EmptyStateView: View {
    private let text: String
    public init(text: String) { self.text = text }
    public var body: some View {
        Text(text)
            .foregroundStyle(AppTheme.Colors.muted)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

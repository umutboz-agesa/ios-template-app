import SwiftUI

/// `Loadable<T>` → görünüm tutkalı.
///
/// DesignSystem saf (sıfır iç bağımlılık) kaldığı için `Loadable`/`SabancimError`'ı
/// bilemez. Bu generic sarmalayıcı o tutkalı tek yerde toplar: `CoreUI`, hem
/// `CoreCommon` (Loadable, SabancimError) hem `DesignSystem` (saf state görünümleri)
/// üzerine kuruludur. Feature'lar her ekranda switch yazmak yerine bunu kullanır.
///
/// Kullanım:
/// ```swift
/// LoadableView(state: viewModel.products, onRetry: { Task { await viewModel.load() } }) { products in
///     List(products) { SabancimProductCard(title: $0.title, subtitle: $0.subtitle) }
/// }
/// ```
public struct LoadableView<Value: Sendable, Content: View>: View {
    private let state: Loadable<Value>
    private let onRetry: (() -> Void)?
    private let content: (Value) -> Content
    private let emptyText: String?

    public init(
        state: Loadable<Value>,
        emptyText: String? = nil,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.state = state
        self.emptyText = emptyText
        self.onRetry = onRetry
        self.content = content
    }

    public var body: some View {
        switch state {
        case .idle, .loading:
            SabancimLoadingView()
        case .failed(let error):
            SabancimErrorView(message: error.userMessage, onRetry: onRetry)
        case .loaded(let value):
            if let emptyText, isEmptyCollection(value) {
                SabancimEmptyStateView(text: emptyText)
            } else {
                content(value)
            }
        }
    }

    private func isEmptyCollection(_ value: Value) -> Bool {
        (value as? any Collection)?.isEmpty ?? false
    }
}

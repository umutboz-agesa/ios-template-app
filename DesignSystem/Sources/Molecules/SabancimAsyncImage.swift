import SwiftUI
import NukeUI

/// Android `Coil` (`AsyncImage` / `rememberAsyncImagePainter`) karşılığı.
///
/// NukeUI `LazyImage` üzerine ince bir DesignSystem sarmalayıcısı. Tüm uygulama
/// görselleri buradan geçer → ortak placeholder, hata durumu ve köşe yuvarlama.
/// Caching, prefetch, task coalescing gibi gelişmiş özellikler Nuke'tan otomatik gelir.
public struct SabancimAsyncImage: View {
    private let url: URL?
    private let cornerRadius: CGFloat
    private let contentMode: ContentMode

    public init(
        url: URL?,
        cornerRadius: CGFloat = AppTheme.Radius.button,
        contentMode: ContentMode = .fill
    ) {
        self.url = url
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
    }

    public init(
        urlString: String?,
        cornerRadius: CGFloat = AppTheme.Radius.button,
        contentMode: ContentMode = .fill
    ) {
        self.init(url: urlString.flatMap(URL.init(string:)), cornerRadius: cornerRadius, contentMode: contentMode)
    }

    public var body: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image.resizable().aspectRatio(contentMode: contentMode)
            } else if state.error != nil {
                placeholder(systemName: "photo")        // hata durumu
            } else {
                placeholder(systemName: nil)             // yükleniyor (shimmer/spinner)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    @ViewBuilder private func placeholder(systemName: String?) -> some View {
        ZStack {
            AppTheme.Colors.surface
            if let systemName {
                Image(systemName: systemName)
                    .foregroundStyle(AppTheme.Colors.primary.opacity(0.4))
            } else {
                ProgressView().tint(AppTheme.Colors.primary)
            }
        }
    }
}

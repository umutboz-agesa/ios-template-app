import SwiftUI

/// Marka logosu. Artık App target'ının kendi asset catalog'unda (`Bundle.main`) —
/// DesignSystem SPM paketi olduğu dönemdeki `Bundle.module` accessor'ı yok.
/// Metin yerine tek kaynaktan logo — Home üst bar, Login vb. hepsi aynı görseli kullanır.
public struct BrandLogo: View {
    private let height: CGFloat

    public init(height: CGFloat = 28) {
        self.height = height
    }

    public var body: some View {
        Image("BrandLogo")
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .accessibilityLabel("Sabancım")
    }
}

#Preview {
    BrandLogo(height: 44).padding()
}

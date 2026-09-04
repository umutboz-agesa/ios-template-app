import SwiftUI

/// Marka logosu (Sabancım). DesignSystem asset catalog'undan (`Bundle.module`) yüklenir.
/// Metin yerine tek kaynaktan logo — Home üst bar, Login vb. hepsi aynı görseli kullanır.
public struct BrandLogo: View {
    private let height: CGFloat

    public init(height: CGFloat = 28) {
        self.height = height
    }

    public var body: some View {
        Image("BrandLogo", bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .accessibilityLabel("Sabancım")
    }
}

#Preview {
    BrandLogo(height: 44).padding()
}

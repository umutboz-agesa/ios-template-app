import SwiftUI

/// Uygulama geneli ekran taban protokolü.
///
/// NOT: superapp'teki gerçek `BaseView`, kendi yazdığınız `AppInsightSDK`
/// (realtime popup & bildirim portalı) üzerinden `trackScreen(_:)` çağırıyordu.
/// Bu template'te AppInsightSDK bilerek çıkarıldı (private repo bağımlılığı
/// istemiyorsunuz) — `screenName` alanı ve `.onAppear` kancası duruyor, kendi
/// analytics SDK'nızı (Firebase Analytics, Amplitude, ya da AppInsightSDK'yı
/// geri eklemek isterseniz) buraya bağlayın.
///
/// Kullanım:
/// ```swift
/// struct HomeView: BaseView {
///     var screenBody: some View { ... }          // eskiden: var body
/// }
/// // screenName default = "HomeView". Özelleştirmek için:
/// //   var screenName: String { "Ana Sayfa" }
/// ```
@MainActor
public protocol BaseView: View {
    associatedtype ScreenBody: View

    /// Ekran adı (funnel step'iyle eşleşir). Default: tip adı.
    var screenName: String { get }

    /// Ekranın içeriği — normalde `body` yazacağın yer.
    @ViewBuilder var screenBody: ScreenBody { get }
}

public extension BaseView {
    var screenName: String { String(describing: Self.self) }

    var body: some View {
        screenBody
            .onAppear {
                // TODO: kendi analytics SDK'nızı bağlayın, örn: Analytics.trackScreen(screenName)
            }
    }
}

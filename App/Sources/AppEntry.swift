import SwiftUI
import CoreNavigation
import DesignSystem

@main
struct iOSTemplateApp: App {
    @State private var navigator = AppNavigator()
    @AppStorage(AppThemeStorage.key) private var appTheme: AppTheme = .dark

    init() {
        AppComposition.bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(navigator)
                .preferredColorScheme(appTheme.colorScheme)
        }
    }
}

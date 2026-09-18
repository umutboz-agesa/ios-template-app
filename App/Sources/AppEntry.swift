import SwiftUI

@main
struct iOSTemplateApp: App {
    @State private var navigator = AppNavigator()
    @AppStorage(ThemeStorage.key) private var appTheme: Theme = .dark

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

# iOSTemplate

## Proje ağacı

```
iOSTemplate.xcodeproj/     App target'ı: App/Sources + TÜM Domain/ + Feature/ dosyaları burada derleniyor
Config/                    Prd/Preprod/Tst/Pilot/Mock.xcconfig — BUNDLE_ID buradan
App/
  Sources/                 AppEntry (@main), AppComposition (swift-dependencies bootstrap), RootView
  Resources/Info.plist
Domain/                    ← App target'ının düz kaynağı
  Identity/Sources/        SessionManager HARİÇ hepsi (UseCase'ler, UserSession, IdentityDependencies)
  Platform/Sources/        CheckVersionUseCase, VersionRepository contract'ı, PlatformDependencies
Feature/                   ← App target'ının düz kaynağı
  Splash/Sources/{Presentation,Data}
  Login/Sources/{Presentation,Data}
  Home/Sources/{Presentation,Data}
Modules/                   ←(App target'ı bunları import eder)
  Core/Common/              CoreCommon — SabancimError, SabancimResult, Loadable<T>
  Core/Navigation/          CoreNavigation — AppNavigator, SabancimRoute
  Core/Presentation/        CorePresentation — BaseView, LoadableView
  Core/Session/             CoreSession — SessionManaging + SessionManager (bu turda yeni)
  DesignSystem/              DesignSystem — Atoms/Molecules/States/Theme + Media.xcassets
  Data/Network/              DataNetwork — HTTPClient, Interceptors, APIEnvelope, ErrorMapper, NetworkEnvironment, Endpoints
```

## Hemen açmak için

1. `iOSTemplate.xcodeproj`'u aç — proje navigatöründe `Domain/` ve `Feature/`
   klasörlerini App'in diğer dosyalarıyla aynı yerde, düz Swift dosyaları
   olarak göreceksiniz (Modules/ altındakiler hâlâ paket referansı olarak
   görünür).
2. Signing & Capabilities'te kendi Team'ini seç.
3. **iOSTemplate Mock** şemasıyla çalıştır → Splash → Login (6+ haneli
   şifre) → Home.

## Yeni feature eklerken

`Feature/Home`'un yanına `Feature/<Ad>/Sources/{Presentation,Data}` olarak
düz klasör açın — Package.swift YOK, sadece dosyaları Xcode'da App
target'ına sürükleyin (ya da "Add Files to iOSTemplate..."). `Modules/`
altındaki paylaşılan paketleri (`DesignSystem`, `CorePresentation`,
`CoreNavigation`, `CoreCommon`, `DataNetwork`, `CoreSession`) normal
`import` ile kullanırsınız; `Domain/`/`Feature/` içi diğer dosyalarla
aranızda import YOK (hepsi aynı target/modül).

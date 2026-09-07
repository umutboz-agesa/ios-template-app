# iOSTemplate

## Proje ağacı

```
iOSTemplate.xcodeproj/   Tek target — TÜM aşağıdaki klasörler Sources build phase'inde
Config/                  Prd/Preprod/Tst/Pilot/Mock.xcconfig
App/                     AppEntry, AppComposition, RootView, MainTabView, AppNavHost, RootTab
Core/
  Common/Sources/         SabancimError, SabancimResult, Loadable<T>
  Navigation/Sources/      AppNavigator, SabancimRoute
  Presentation/Sources/    BaseView, LoadableView
  Session/Sources/         SessionManaging + SessionManager (bkz. aşağıdaki NOT)
Data/
  Network/Sources/         HTTPClient, Interceptors, APIEnvelope, ErrorMapper, NetworkEnvironment, Endpoints
DesignSystem/
  Sources/                 Atoms/Molecules/States/Theme + Resources/Media.xcassets
Domain/                   (değişmedi) Identity, Platform, Policy
Feature/                  (değişmedi) Splash, Login, Home, Profile
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

`Feature/Home`'un yanına `Feature/<Ad>/Sources/{Presentation,Data}`
açın — Package.swift yok, dosyaları Xcode'a ekleyin ("Add Files to
iOSTemplate..."), `Core/`/`Data/`/`DesignSystem/` altındaki paylaşılan
kodu normal `import` OLMADAN (aynı target) doğrudan kullanabilirsiniz.

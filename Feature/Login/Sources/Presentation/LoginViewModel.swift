import Foundation
import Observation
import Dependencies
import CoreCommon
import CoreNavigation
import UIKit   // UIDevice.identifierForVendor
import DataNetwork

/// Android `LoginViewModel` (@HiltViewModel + StateFlow) karşılığı.
/// `@Observable` → StateFlow, `@Dependency` → Hilt inject.
@MainActor
@Observable
public final class LoginViewModel {
    
    enum LoginType {
        case firstLogin
        case login(name: String)
    }
    
    public var username: String = ""
    public var password: String = ""
    public var hasAcceptedContract: Bool = false
    var loginType: LoginType = .firstLogin
    public private(set) var state: Loadable<Void> = .idle
    
    /// `Giriş Yap` butonunun aktifliği. `.firstLogin`'de sözleşme onayı ZORUNLU —
    /// `LoginRegistrationUseCase`'in kendi validation'ı da bunu reddediyor, ama
    /// kullanıcıyı isteği atıp hata almaya bırakmak yerine butonu önden kilitliyoruz.
    public var canSubmit: Bool {
        switch loginType {
        case .firstLogin:
            username.count == 11 && password.count == 6 && hasAcceptedContract
        case .login:
            password.count == 6
        }
    }

    @ObservationIgnored @Dependency(\.authRepository) private var repository
    @ObservationIgnored @Dependency(\.userSession) private var userSession
    @ObservationIgnored @Dependency(\.loginRegistrationRepository) private var loginRegistrationRepository

    /// Login başarılı olduğunda App katmanına haber vermek için callback
    /// (feature → feature coupling yok; navigasyonu App yönetir).
    private let onFinished: (SabancimRoute) -> Void

    public init(prefillUsername: String? = nil, onFinished: @escaping (SabancimRoute) -> Void = { _ in }) {
        if let prefillUsername {
            self.loginType = .login(name: prefillUsername)
        }
        self.onFinished = onFinished
        if NetworkEnvironment.current.isMock {
            self.username = "12345678901"
        }
    }

    public func login() async {
        state = .loading
        switch loginType {
        case .firstLogin:
            let useCase = LoginRegistrationUseCase(repository: loginRegistrationRepository)
            let result = await useCase(makeInput())
            state = result.toLoadable()
            if case .success = result {
                onFinished(.otp(identityNumber: username, password: password))
            }
        case .login(let name):
            let useCase = LoginUseCase(repository: repository, session: userSession)
            let credentials = LoginCredentials(
                password: password,
                deviceUUID: UIDevice.current.identifierForVendor?.uuidString ?? ""
            )
            let result = await useCase(credentials)
            
            // Loadable<AuthenticationResult> → Loadable<Void> dönüşümü Loadable'ın
            // kendi case'lerine dokunmadan yapılıyor — sadece AgesaResult'ın bilinen
            // .success/.failure'ı üzerinden, sonra zaten çalışan .toLoadable() ile.
            let voidResult: SabancimResult<Void>
            switch result {
            case .success:
                voidResult = .success(())
            case let .failure(error):
                voidResult = .failure(error)
            }
            state = voidResult.toLoadable()
            
            if case .success = result {
                // `authResult.needsPasswordChange`/`.needsDisclaimer`'a göre farklı
                // bir route'a gitmek gerekebilir — henüz ele alınmadı.
                onFinished(.home)
            }
        }
    }
    
    private func makeInput() -> LoginRegistrationCredentials {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let osVersion = UIDevice.current.systemVersion
        let model = UIDevice.current.model
        return LoginRegistrationCredentials(
            identityNumber: username,
            password: password,
            contractTextReaded: hasAcceptedContract,
            deviceUUID: uuid,
            brand: "Apple",
            model: model,
            osVersion: osVersion,
            appVersion: version
        )
    }
}

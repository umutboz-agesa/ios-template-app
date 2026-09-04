import Foundation
import CoreSession
import Dependencies
import DataNetwork
import CoreCommon

/// Composition root — superapp'teki `AppComposition.swift`'in birebir aynısı,
/// Policy/Pension'a ait satırlar çıkarılmış hali. swift-dependencies'in
/// `prepareDependencies` fonksiyonuyla gerçek implementasyonları
/// `DependencyValues`'e bağlar; Domain katmanındaki `@Dependency(\.xxx)`
/// property wrapper'ları bunları otomatik alır — App katmanı dışında elle
/// "inject" edilen hiçbir yer yok.
enum AppComposition {
    static let environment: NetworkEnvironment = .current

    /// Uygulama açılışında bir kez çağrılır; canlı bağımlılıkları kaydeder.
    static func bootstrap() {
        prepareDependencies { values in
            let session = values.sessionManager   // tekil SessionManager

            // mock flavor → ağ yok
            guard let baseURL = environment.baseURL else {
                // Mock'ta login'i geçebilmek için her zaman başarılı dönen sahte
                // authRepository bağla. versionRepository ve pensionContractsSummaryRepository
                // zaten kendi DependencyKey default'larıyla (sırasıyla .upToDate,
                // gerçekçi örnek veri) çalıştığı için burada elle bağlamaya gerek yok.
                values.authRepository = MockAuthRepository()
                return
            }

            let chain = InterceptorChain([
                HeaderInterceptor(referer: baseURL.absoluteString),
                AuthInterceptor(session: session),
            ])
            let client = HTTPClient(baseURL: baseURL, chain: chain, sessionManager: session)

            values.authRepository = DataIdentityModule.makeRepository(client: client, session: session)
            values.startLoginRepository = DataIdentityModule.makeStartLoginRepository(client: client)
            values.loginRegistrationRepository = DataIdentityModule.makeLoginRegistrationRepository(client: client)
            values.otpConfirmationRepository = DataIdentityModule.makeOtpConfirmationRepository(client: client)
            values.versionRepository = DataPlatformModule.makeVersionRepository(client: client)
            values.pensionContractsSummaryRepository = DataPolicyModule.makePensionContractsSummaryRepository(client: client)
        }
    }
}

/// Yalnızca Mock flavor için — login'i başarılı sayan sahte repo (dev convenience).
/// Prod/Tst/Preprod/Pilot bu satıra hiç girmez (baseURL != nil).
private struct MockAuthRepository: AuthRepository {
    func login(_ credentials: LoginCredentials) async -> SabancimResult<AuthenticationResult> {
        .success(AuthenticationResult(
            user: AuthenticatedUser(customerNumber: 10023456, name: "Test", surname: "Kullanıcı", birthdate: ""),
            userAnalyticId: "",
            needsPasswordChange: false,
            needsDisclaimer: false,
            lastLoggedInTime: "",
            lastWrongLoginTime: ""
        ))
    }
    func logout() async {}
}

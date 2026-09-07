import Dependencies

/// swift-dependencies kayıtları — Android Hilt `@Module` / `@Provides` karşılığı.
///
/// `SessionManager` tüm uygulama boyunca tekil (Hilt `@Singleton`).
/// `AuthRepository`'nin `liveValue`'su `Feature:Auth`'ta override edilir
/// (impl orada yaşar — Android `@Binds` feature di modülünde olduğu gibi).
private enum SessionManagerKey: DependencyKey {
    static let liveValue: any SessionManaging = SessionManager()
    static let testValue: any SessionManaging = SessionManager()
}

public extension DependencyValues {
    var sessionManager: any SessionManaging {
        get { self[SessionManagerKey.self] }
        set { self[SessionManagerKey.self] = newValue }
    }
}

/// AuthRepository için DI anahtarı. liveValue burada "unimplemented" —
/// gerçek implementasyon Feature:Auth'ta `prepareDependencies` ile bağlanır.
public enum AuthRepositoryKey: TestDependencyKey {
    public static var testValue: any AuthRepository {
        UnimplementedAuthRepository()
    }
}

public extension DependencyValues {
    var authRepository: any AuthRepository {
        get { self[AuthRepositoryKey.self] }
        set { self[AuthRepositoryKey.self] = newValue }
    }
}

/// Test/placeholder repo — gerçek impl bağlanmazsa kullanılır.
struct UnimplementedAuthRepository: AuthRepository {
    func login(_ credentials: LoginCredentials) async -> SabancimResult<AuthenticationResult> {
        .failure(.unknown(message: "AuthRepository bağlanmadı."))
    }
    func logout() async {}
}

/// `StartLoginRepository` için DI anahtarı.
public enum StartLoginRepositoryKey: DependencyKey {
    /// Composition root'ta gerçek implementasyon bağlanmazsa kullanılan zararsız varsayılan.
    public static let liveValue: StartLoginRepository = NotYetImplementedStartLoginRepository()
 
    /// Testte kullanılan versiyon — biri gerçek bir implementasyon bağlamayı unutup
    /// bu dependency'e ihtiyaç duyan bir test yazarsa, sessizce geçmek yerine patlar.
    public static let testValue: StartLoginRepository = UnimplementedStartLoginRepository()
}
 
public extension DependencyValues {
    var startLoginRepository: any StartLoginRepository {
        get { self[StartLoginRepositoryKey.self] }
        set { self[StartLoginRepositoryKey.self] = newValue }
    }
}
 
struct NotYetImplementedStartLoginRepository: StartLoginRepository {
    func startLogin(_ request: StartLoginRequest) async -> SabancimResult<RecognizedUser?> {
//        .success(RecognizedUser(firstName: "Hakan", lastName: "Uğraş"))
        .failure(.unknown(message: "StartLoginRepository test'te override edilmedi."))
    }
}
 
struct UnimplementedStartLoginRepository: StartLoginRepository {
    func startLogin(_ request: StartLoginRequest) async -> SabancimResult<RecognizedUser?> {
        .failure(.unknown(message: "StartLoginRepository test'te override edilmedi."))
    }
}

/// `LoginRegistrationRepository` için DI anahtarı. `VersionCheckRepositoryKey` ile
/// aynı desen — liveValue BİLEREK yok: bu kritik yol (gerçek login), sessizce
/// "henüz yok" davranışına düşmemeli, bootstrap'ta bağlanmazsa canlı context'te
/// fatalError vermeli (`StartLoginRepositoryKey`'in aksine, o kasıtlı olarak toleranslıydı).
public enum LoginRegistrationRepositoryKey: DependencyKey {
    public static let liveValue: LoginRegistrationRepository = NotYetImplementedLoginRegistrationRepository()
    
    public static var testValue: LoginRegistrationRepository {
        UnimplementedLoginRegistrationRepository()
    }
}
 
public extension DependencyValues {
    var loginRegistrationRepository: any LoginRegistrationRepository {
        get { self[LoginRegistrationRepositoryKey.self] }
        set { self[LoginRegistrationRepositoryKey.self] = newValue }
    }
}
 
struct UnimplementedLoginRegistrationRepository: LoginRegistrationRepository {
    func loginRegistration(_ credentials: LoginRegistrationCredentials) async -> SabancimResult<Void> {
        .failure(.unknown(message: "LoginRegistrationRepository bağlanmadı."))
    }
}

struct NotYetImplementedLoginRegistrationRepository: LoginRegistrationRepository {
    func loginRegistration(_ credentials: LoginRegistrationCredentials) async -> SabancimResult<Void> {
        .success(Void())
    }
}

/// `OtpConfirmationRepository` için DI anahtarı. `LoginRegistrationRepositoryKey` ile
/// aynı desen — bu gerçek oturumu kuran kritik adım, sessizce "henüz yok"a düşmemeli.
public enum OtpConfirmationRepositoryKey: DependencyKey {
    public static let liveValue: OtpConfirmationRepository = NotYetImplementedOtpConfirmationRepository()
    
    public static var testValue: OtpConfirmationRepository {
        UnimplementedOtpConfirmationRepository()
    }
}
 
public extension DependencyValues {
    var otpConfirmationRepository: any OtpConfirmationRepository {
        get { self[OtpConfirmationRepositoryKey.self] }
        set { self[OtpConfirmationRepositoryKey.self] = newValue }
    }
}
 
struct UnimplementedOtpConfirmationRepository: OtpConfirmationRepository {
    func confirmOtp(_ request: OtpConfirmationRequest) async -> SabancimResult<AuthenticationResult> {
        .failure(.unknown(message: "OtpConfirmationRepository bağlanmadı."))
    }
}

struct NotYetImplementedOtpConfirmationRepository: OtpConfirmationRepository {
    func confirmOtp(_ request: OtpConfirmationRequest) async -> SabancimResult<AuthenticationResult> {
        .success(AuthenticationResult(user: .init(customerNumber: 0, name: "", surname: "", birthdate: ""), userAnalyticId: "", needsPasswordChange: false, needsDisclaimer: false, lastLoggedInTime: "", lastWrongLoginTime: ""))
    }
}

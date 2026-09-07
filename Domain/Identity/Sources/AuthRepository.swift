import Foundation

/// Domain model — kimliği doğrulanmış kullanıcı.
/// Servisin `user` objesini birebir taşır (Android `login/UserModel`).
/// `fullName` ve `customerId` **türetilmiş** (stored değil) — kod tekrarı olmasın.
public struct AuthenticatedUser: Equatable, Sendable {
    public let name: String
    public let surname: String
    public let customerNumber: Int
    public let userAnalyticId: String
    /// Profil detayları — gerçek login/OTP response'unda `user` altında gelir (mock'ta nil).
    public let email: String?
    public let phone: String?
    public let identityNumber: String?
    public let birthdate: String

    public init(
        customerNumber: Int,
        name: String,
        surname: String,
        userAnalyticId: String = "",
        birthdate: String,
        email: String? = nil,
        phone: String? = nil,
        identityNumber: String? = nil,
        
    ) {
        self.customerNumber = customerNumber
        self.name = name
        self.surname = surname
        self.userAnalyticId = userAnalyticId
        self.birthdate = birthdate
        self.email = email
        self.phone = phone
        self.identityNumber = identityNumber
        
    }

    /// Ad Soyad (türetilmiş).
    public var fullName: String {
        "\(name) \(surname)".trimmingCharacters(in: .whitespaces)
    }
    /// Müşteri no'nun String gösterimi (türetilmiş; servis `long` döndürür).
    public var customerId: String { String(customerNumber) }
}

/// Eski VIPER'daki `LoginParameter` karşılığı. Not: `username`/`identityNumber`
/// YOK — bu, cihazın zaten tanındığı (`StartLoginRepository` ile "recognized")
/// akış, kimlik server'da session/cookie üzerinden zaten biliniyor; sadece
/// şifre + cihaz kimliği gönderiliyor. POC'taki `Credentials(username:password:)`
/// bu yüzden gerçeğe uymuyordu, yerini bu aldı.
public struct LoginCredentials: Sendable, Equatable {
    public let password: String
    public let deviceUUID: String

    public init(password: String, deviceUUID: String) {
        self.password = password
        self.deviceUUID = deviceUUID
    }
}

/// Android `:domain:identity` `AuthRepository` contract'ı karşılığı.
public protocol AuthRepository: Sendable {
    func login(_ credentials: LoginCredentials) async -> SabancimResult<AuthenticationResult>
    func logout() async
}

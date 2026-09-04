import Foundation

/// Android `:data` `Endpoints.kt` karşılığı (Volley `NetworkConstants.java` port'u).
/// İç içe `enum` namespace'leri ile ~177 endpoint sabiti organize edilir.
/// Burada PoC için Auth alt-kümesi mevcut; yeni faz = yeni nested enum/sabit.
public enum Endpoints {

    public enum Login {
        public static let startLogin = "auth/login/startLogin"
        public static let login = "auth/login/login"
        public static let registration = "auth/login/registration"
        public static let biometricLogin = "rest/login/biometric"
        public static let otpConfirmation = "auth/login/otpConfirmation"
        public static let createNewPassword = "rest/login/create-new-password"
        public static let forgetMe = "rest/login/forget-me"
        public static let versionCheck = "rest/login/version-check"
    }

    public enum Customer {
        private static let baseUrl = "api/mobile/customer"
        public static let accountChangePassword = "rest/customer/account/change-password"
        public static let leads = "rest/customer/leads"
        public static let pensionContractsAndSummary = baseUrl + "/pensionContractsAndSummary"
        public static let pensionContractDetail = baseUrl + "/pensionContractDetail"
    }

    public enum Auth {
        public static let keepAlive = "rest/auth/keep-alive"
        public static let akbankAppToAppAuth = "rest/auth/akbank-app-to-app"
    }

}

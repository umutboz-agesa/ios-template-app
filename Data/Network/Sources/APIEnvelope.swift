import Foundation

/// Android `:data` `ApiEnvelope<T>` karşılığı.
/// Backend tüm yanıtları bu zarfla döner: { success, data, customData, error, validations }.
public struct APIEnvelope<T: Decodable & Sendable>: Decodable, Sendable {
    public let success: Bool
    public let data: T?
    public let error: APIError?
    public let validations: [APIValidation]?

    public struct APIError: Decodable, Sendable {
        public let errorCode: String?
        public let message: String?
    }

    public struct APIValidation: Decodable, Sendable {
        public let field: String?
        public let message: String?
    }

    /// `ApiEnvelope<T> → T` (Android `.unwrap()`). success=false ise SabancimError fırlatır.
    public func unwrap() throws -> T {
        guard success else {
            if let validations, !validations.isEmpty {
                throw SabancimError.validation(
                    validations.map { ValidationItem(field: $0.field ?? "", message: $0.message ?? "") }
                )
            }
            if error?.errorCode == "warning_token_expire" {
                throw SabancimError.tokenExpired
            }
            throw SabancimError.unknown(message: error?.message ?? "İşlem başarısız.")
        }
        guard let data else {
            throw SabancimError.unknown(message: "Boş yanıt.")
        }
        return data
    }
}

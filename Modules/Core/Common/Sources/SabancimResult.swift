import Foundation

/// Domain repository / use-case dönüş tipi.
/// Android `:core:common` `Result<T>` (Success / Error / Loading) karşılığı.
///
/// Swift'in stdlib `Result`'ı kullanılır; `Loading` ayrı bir UI-state tipidir
/// (`Loadable`), çünkü Swift `async` fonksiyonları zaten "tamamlanınca sonuç döner"
/// semantiğinde — loading bir ara durum değil, çağıranın state'i.
public typealias SabancimResult<T: Sendable> = Result<T, SabancimError>

/// UI state için yükleme sarmalayıcı (Android'de `Result.Loading` + StateFlow
/// kombinasyonunun SwiftUI `@Observable` karşılığı).
public enum Loadable<Value: Sendable>: Sendable {
    case idle
    case loading
    case loaded(Value)
    case failed(SabancimError)

    public var value: Value? {
        if case let .loaded(v) = self { return v }
        return nil
    }

    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    public var error: SabancimError? {
        if case let .failed(e) = self { return e }
        return nil
    }
}

// `Loadable<Value>` `Value: Sendable` ister; bu yüzden extension'ı Sendable
// Success'e kısıtlıyoruz (Swift 6 strict concurrency). Domain sonuçları zaten
// Sendable olduğundan çağıranlar etkilenmez.
public extension Result where Failure == SabancimError, Success: Sendable {
    /// `when(success:error:)` Kotlin pattern'inin kısa karşılığı.
    func toLoadable() -> Loadable<Success> {
        switch self {
        case .success(let v): .loaded(v)
        case .failure(let e): .failed(e)
        }
    }
}

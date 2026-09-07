import Foundation

/// Android `:data` `ErrorMapper` karşılığı.
/// HTTP status / URLError / Swift error → `SabancimError`. README'deki hata zinciri tablosu birebir.
public enum ErrorMapper {

    /// HTTP status koduna göre eşleme (Android `HttpException` dalı).
    public static func map(statusCode: Int) -> SabancimError {
        switch statusCode {
        case 401, 403: .auth
        case 404: .notFound
        case 422: .validation([])
        case 500...599: .network(code: statusCode)
        default: .network(code: statusCode)
        }
    }

    /// Yakalanan Swift hatasından eşleme (Android `IOException`/`SSLException` dalları).
    public static func map(error: Error) -> SabancimError {
        if let agesa = error as? SabancimError { return agesa }
        let nsError = error as NSError
        switch nsError.domain {
        case NSURLErrorDomain:
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorTimedOut:
                return .reachability
            case NSURLErrorSecureConnectionFailed,
                 NSURLErrorServerCertificateUntrusted,
                 NSURLErrorServerCertificateHasBadDate,
                 NSURLErrorCancelled where nsError.code == NSURLErrorCancelled:
                return .ssl
            default:
                return .unknown(message: nsError.localizedDescription)
            }
        default:
            return .unknown(message: nsError.localizedDescription)
        }
    }
}

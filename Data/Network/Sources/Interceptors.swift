import Foundation

/// Android OkHttp interceptor zincirinin karşılığı.
///
/// URLSession'ın yerleşik interceptor zinciri yoktur; bu yüzden istek gönderilmeden
/// önce `URLRequest`'i sırayla dönüştüren `RequestInterceptor` protokolü ile aynı
/// davranış modellenir. Cert pinning ise ayrı `URLSessionDelegate` ile yapılır.
public protocol RequestInterceptor: Sendable {
    func adapt(_ request: URLRequest) async -> URLRequest
}

/// 1. HeaderInterceptor — Accept, Referer (Android `HeaderInterceptor`).
public struct HeaderInterceptor: RequestInterceptor {
    private let referer: String
    public init(referer: String) { self.referer = referer }

    public func adapt(_ request: URLRequest) async -> URLRequest {
        var r = request
        r.setValue("application/json", forHTTPHeaderField: "Accept")
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")
        r.setValue(referer, forHTTPHeaderField: "Referer")
        return r
    }
}

/// 2. AuthInterceptor — Cookie: JSESSIONID (Android `AuthInterceptor`).
/// İzinli cross-layer: Data → DomainIdentity (SessionManager contract'ını okur).
public struct AuthInterceptor: RequestInterceptor {
    private let session: any SessionManaging
    public init(session: any SessionManaging) { self.session = session }

    public func adapt(_ request: URLRequest) async -> URLRequest {
        var r = request
        if let cookie = await session.sessionCookie {
            r.setValue("JSESSIONID=\(cookie)", forHTTPHeaderField: "Cookie")
        }
        return r
    }
}

/// İstek dönüştürme zincirini sırayla uygular.
public struct InterceptorChain: Sendable {
    private let interceptors: [any RequestInterceptor]
    public init(_ interceptors: [any RequestInterceptor]) { self.interceptors = interceptors }

    public func apply(to request: URLRequest) async -> URLRequest {
        var current = request
        for interceptor in interceptors {
            current = await interceptor.adapt(current)
        }
        return current
    }
}

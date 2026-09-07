import Foundation

/// HTTP metodları.
public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
}

/// Android `Retrofit` + `OkHttp` istemcisinin karşılığı.
/// İstek kurar, interceptor zincirini uygular, status kodunu eşler ve
/// `Set-Cookie` yanıtından JSESSIONID'i SessionManager'a yazar
/// (Android `SessionCookieInterceptor` response tarafı).
public actor HTTPClient {
    private let baseURL: URL
    private let session: URLSession
    private let chain: InterceptorChain
    private let sessionManager: any SessionManaging
    private let decoder: JSONDecoder

    public init(
        baseURL: URL,
        chain: InterceptorChain,
        sessionManager: any SessionManaging,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.chain = chain
        self.sessionManager = sessionManager
        self.session = session
        self.decoder = JSONDecoder()
    }

    /// `T = APIEnvelope<Body>` beklenir. unwrap çağrısı RemoteDataSource'ta yapılır.
    public func request<T: Decodable & Sendable>(
        _ path: String,
        method: HTTPMethod = .post,
        body: (any Encodable & Sendable)? = nil,
        as type: T.Type
    ) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        #if DEBUG
        print("🌐 [HTTP] → \(method.rawValue) \(request.url?.absoluteString ?? "-")")
        #endif
        request = await chain.apply(to: request)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw SabancimError.unknown(message: "Geçersiz yanıt.")
        }

        #if DEBUG
        print("🌐 [HTTP] \(http.statusCode) ← \(request.url?.lastPathComponent ?? "-") | Set-Cookie=\(http.value(forHTTPHeaderField: "Set-Cookie") ?? "-") token=\(http.value(forHTTPHeaderField: "token") ?? "-") Authorization=\(http.value(forHTTPHeaderField: "Authorization") ?? "-")")
        #endif

        // SessionCookieInterceptor (response): Set-Cookie → JSESSIONID kaydet
        if let setCookie = http.value(forHTTPHeaderField: "Set-Cookie"),
           let jsessionid = Self.parseJSessionID(setCookie) {
            await sessionManager.updateSessionCookie(jsessionid)
        }

        guard (200..<300).contains(http.statusCode) else {
            #if DEBUG
            print("🌐 [HTTP] \(http.statusCode) ← \(request.url?.absoluteString ?? "-") body=\(String(data: data, encoding: .utf8)?.prefix(400) ?? "")")
            #endif
            throw ErrorMapper.map(statusCode: http.statusCode)
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            print("🌐 [HTTP] decode FAIL \(request.url?.absoluteString ?? "-"): \(error)")
            #endif
            throw error
        }
    }

    private static func parseJSessionID(_ header: String) -> String? {
        header
            .split(separator: ";")
            .first { $0.contains("JSESSIONID=") }
            .map { $0.replacingOccurrences(of: "JSESSIONID=", with: "").trimmingCharacters(in: .whitespaces) }
    }
}

/// Android `BaseRemoteDataSource` (`apiCall { }`) karşılığı.
/// Tüm RemoteDataSource'lar bunu extend eder; try/catch + SabancimError eşlemesini merkezîleştirir.
open class BaseRemoteDataSource: @unchecked Sendable {
    public init() {}

    /// `apiCall { api.x().unwrap().map { it.toDomain() } }`
    public func apiCall<T: Sendable>(_ block: () async throws -> T) async -> SabancimResult<T> {
        do {
            return .success(try await block())
        } catch {
            return .failure(ErrorMapper.map(error: error))
        }
    }
}

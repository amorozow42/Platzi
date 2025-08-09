//
//  HTTPClient.swift
//  GroceryApp
//
//  Created by Mohammad Azam on 5/7/23.
//

import Foundation

protocol HTTPClientProtocol {
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T
}

enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete
    case put(Data?)
    
    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
        }
    }
}

struct Resource<T: Codable> {
    let endpoint: Endpoint
    var method: HTTPMethod = .get([])
    var headers: [String: String]? = nil
    var modelType: T.Type
}

struct HTTPClient: HTTPClientProtocol {
    
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
    }

    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        do {
            return try await performRequest(resource)
        } catch NetworkError.unauthorized {
            // Attempt to refresh token
            do {
                try await refreshToken()
                return try await performRequest(resource) // Retry once
            } catch {
                throw NetworkError.unauthorized // Still unauthorized after refresh
            }
        }
    }

    private func performRequest<T: Codable>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.endpoint.url)

        switch resource.method {
        case .get(let queryItems):
                var components = URLComponents(url: resource.endpoint.url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }
            request.url = url

        case .post(let data), .put(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data

        case .delete:
            request.httpMethod = resource.method.name
        }

        // Add Authorization header
        if let token = Keychain<String>.get("accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let headers = resource.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound 
        default:
            throw NetworkError.undefined(data, httpResponse)
        }

        do {
            return try JSONDecoder().decode(resource.modelType, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    // If you want you can move this into a separate struct like TokenService etc 
    func refreshToken() async throws {
        guard let refreshToken = Keychain<String>.get("refreshToken") else {
            throw TokenError.refreshTokenMissing
        }

        let body = try JSONEncoder().encode(["refreshToken": refreshToken])
        let resource = Resource(
            endpoint: .refreshToken,
            method: .post(body),
            modelType: RefreshTokenResponse.self
        )

        let response = try await performRequest(resource)
        Keychain.set(response.accessToken, forKey: "accessToken")
        Keychain.set(response.refreshToken, forKey: "refreshToken")
    }
}

extension HTTPClient {
    static let development = HTTPClient()
}



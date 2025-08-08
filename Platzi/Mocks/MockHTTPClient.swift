//
//  MockHTTPClient.swift
//  Platzi
//
//  Created by Mohammad Azam on 8/7/25.
//

import Foundation

struct MockHTTPClient: HTTPClientProtocol {
    
    func load<T>(_ resource: Resource<T>) async throws -> T where T : Decodable, T : Encodable {
        
        switch resource.endpoint {
            case .createCategory, .register, .refreshToken, .addProduct, .login:
                throw URLError(.unsupportedURL)
            case .categories:
                return PreviewData.load(fileName: "categories")
            case .productsByCategory(_):
                return PreviewData.load(fileName: "productsByCategory")
            case .deleteProduct(_):
                return true as! T
            case .locations:
                return PreviewData.load(fileName: "locations")
        }
    }
}

extension MockHTTPClient {
    static let preview = MockHTTPClient()
}

struct PreviewData {
    
    static func load<T: Codable>(fileName: String) -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            fatalError("Could not find \(fileName).json in the bundle.")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode \(fileName).json: \(error)")
        }
    }
}


//
//  Constants.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/17/25.
//

import Foundation

struct Constants {
    
    struct Urls {
        static let register = URL(string: "https://api.escuelajs.co/api/v1/users/")!
        static let login = URL(string: "https://api.escuelajs.co/api/v1/auth/login")!
        static let refreshToken = URL(string: "https://api.escuelajs.co/api/v1/auth/refresh-token")!
        static let categories = URL(string: "https://api.escuelajs.co/api/v1/categories")!
        static let addProduct = URL(string: "https://api.escuelajs.co/api/v1/products/")!
        
        static func productsBy(categoryId: Int) -> URL {
            URL(string: "https://api.escuelajs.co/api/v1/categories/\(categoryId)/products")!
        }
    }
}

enum Endpoint {
    
    private static let baseURL = URL(string: "https://api.escuelajs.co/api/v1")!

    case register
    case login
    case refreshToken
    case categories
    case addProduct
    case productsByCategory(Int)
    case deleteProduct(Int)

    var path: String {
        switch self {
        case .register:
            return "/users/"
        case .login:
            return "/auth/login"
        case .refreshToken:
            return "/auth/refresh-token"
        case .categories:
            return "/categories"
        case .addProduct:
            return "/products/"
        case .productsByCategory(let categoryId):
            return "/categories/\(categoryId)/products"
        case .deleteProduct(let productId):
            return "/products/\(productId)"
        }
    }

    var url: URL {
        Self.baseURL.appending(path: path)
    }
}


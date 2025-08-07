//
//  Constants.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/17/25.
//

import Foundation

enum Endpoint {
    
    private static let baseURL = URL(string: "https://api.escuelajs.co/api/v1")!

    case createCategory
    case register
    case login
    case refreshToken
    case categories
    case addProduct
    case productsByCategory(Int)
    case deleteProduct(Int)

    var path: String {
        switch self {
        case .createCategory:
            return "/categories"
        case .register:
            return "/users"
        case .login:
            return "/auth/login"
        case .refreshToken:
            return "/auth/refresh-token"
        case .categories:
            return "/categories"
        case .addProduct:
            return "/products"
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


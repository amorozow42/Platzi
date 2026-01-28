//
//  PlatziStore.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/19/25.
//

import Foundation
import Observation

enum SampleError: Error {
    case operationFailed
}

@MainActor
@Observable
class PlatziStore {
    
    var categories: [Category] = []
    var locations: [Location] = []
    
    let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func loadLocations() async throws {
        let resource = Resource<[Location]>(endpoint: .locations)
        locations = try await httpClient.load(resource)
    }
    
    func createCategory(name: String) async throws {
        let createCategoryRequest = CreateCategoryRequest(name: name, image: URL.randomImageURL)
        let resource = Resource<Category>(endpoint: .createCategory, method: .post(try createCategoryRequest.encode()))
        let category = try await httpClient.load(resource)
        categories.append(category)
    }
    
    func loadCategories() async throws {
        let resource = Resource<[Category]>(endpoint: .categories)
        categories = try await httpClient.load(resource)
    }
    
    func deleteProduct(productId: Int) async throws -> Bool {
        let resource = Resource<Bool>(endpoint: .deleteProduct(productId), method: .delete)
        return try await httpClient.load(resource)
    }
    
    func loadProductsBy(categoryId: Int) async throws -> [Product] {
        let resource = Resource<[Product]>(endpoint: .productsByCategory(categoryId))
        return try await httpClient.load(resource)
    }
    
    func saveProduct(title: String, price: Double, description: String, categoryId: Int, images: [URL]) async throws -> Product {
        let createProductRequest = CreateProductRequest(title: title, price: price, description: description, categoryId: categoryId, images: images)
        let resource = Resource<Product>(endpoint: .addProduct, method: .post(try createProductRequest.encode()))
        let product = try await httpClient.load(resource)
        return product
    }
}

//
//  PlatziStore.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/19/25.
//

import Foundation
import Observation

@MainActor
@Observable
class PlatziStore {
    
    var categories: [Category] = []
    var locations: [Location] = []
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadLocations() async throws {
        let resource = Resource(endpoint: .locations, modelType: [Location].self)
        locations = try await httpClient.load(resource)
    }
    
    func createCategory(name: String) async throws {
        
        let createCategoryRequest = CreateCategoryRequest(name: name, image: URL.randomImageURL)
        let resource = Resource(endpoint: .createCategory, method: .post(try createCategoryRequest.encode()), modelType: Category.self)
        let category = try await httpClient.load(resource)
        categories.append(category)
    }
    
    func loadCategories() async throws {
        let resource = Resource(endpoint: .categories, modelType: [Category].self)
        categories = try await httpClient.load(resource)
    }
    
    func deleteProduct(productId: Int) async throws -> Bool {
        let resource = Resource(endpoint: .deleteProduct(productId), method: .delete, modelType: Bool.self)
        return try await httpClient.load(resource)
    }
    
    func loadProductsBy(categoryId: Int) async throws -> [Product] {
        
        let resource = Resource(endpoint: .productsByCategory(categoryId), modelType: [Product].self)
        return try await httpClient.load(resource)
    }
    
    func saveProduct(title: String, price: Double, description: String, categoryId: Int, images: [URL]) async throws -> Product {
        
        let createProductRequest = CreateProductRequest(title: title, price: price, description: description, categoryId: categoryId, images: images)
        
        let resource = Resource(endpoint: .addProduct, method: .post(try createProductRequest.encode()), modelType: Product.self)
        
        let product = try await httpClient.load(resource)
        return product
    }
    
}

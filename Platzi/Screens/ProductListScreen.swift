//
//  ProductListScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/19/25.
//

import SwiftUI

struct ProductListScreen: View {
    
    let category: Category
    @Environment(PlatziStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showAddProductScreen: Bool = false
    @State private var isLoading: Bool = false
    
    @State private var products: [Product] = []
    
    private func loadProducts() async {
                
        guard !isLoading else { return }
        isLoading = true
        
        defer { isLoading = false }
                
        do {
            products = try await store.loadProductsBy(categoryId: category.id)
        } catch {
            // show error in toast message
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        ZStack {
            if products.isEmpty {
                ContentUnavailableView("No products available", systemImage: "shippingbox")
            } else {
                List(products) { product in
                    NavigationLink {
                        ProductDetailScreen(product: product)
                    } label: {
                        ProductCellView(product: product)
                    }
                }.refreshable(action: {
                    await loadProducts()
                })
            }
        }.overlay(alignment: .center, content: {
            if isLoading {
                ProgressView("Loading...")
            }
        })
        .task {
            await loadProducts()
        }
        .sheet(isPresented: $showAddProductScreen, content: {
            NavigationStack {
                AddProductScreen(selectedCategoryId: category.id) { product in
                    products.append(product)
                }
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Product") {
                    showAddProductScreen = true
                }
            }
        }
        
    }
}

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: product.images.first) { img in
                img.resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            } placeholder: {
                ImagePlaceholderView()
            }
            
            Text(product.title)
        }
    }
}

#Preview {
    NavigationStack {
        ProductListScreen(category: Category(id: 1, name: "Shirts", slug: "shirts", image: URL(string: "https://placehold.co/600x400")!))
            .navigationTitle("Shirts")
    }.environment(PlatziStore(httpClient: .development))
}

//
//  CategoryListScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/19/25.
//

import SwiftUI

struct CategoryListScreen: View {
    
    @Environment(PlatziStore.self) private var store
    @State private var showAddCategoryScreen: Bool = false
    @State private var isLoading: Bool = false
    
    private func loadCategories() async {
        
        defer { isLoading = false }
        
        do {
            isLoading = true
            try await store.loadCategories()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        ZStack {
            
            if store.categories.isEmpty && !isLoading {
                ContentUnavailableView("No products available", systemImage: "shippingbox")
            } else {
                List(store.categories) { category in
                    NavigationLink {
                        ProductListScreen(category: category)
                            .navigationTitle(category.name)
                    } label: {
                        CategoryCellView(category: category)
                    }
                }
            }
        }
        .overlay(alignment: .center, content: {
            if isLoading {
                ProgressView("Loading...")
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Category") {
                    showAddCategoryScreen = true
                }
            }
        })
        .sheet(isPresented: $showAddCategoryScreen, content: {
            NavigationStack {
                AddCategoryScreen()
                    .withToast()
            }
        })
        .task {
            await loadCategories()
        }.navigationTitle("Categories")
    }
}

struct CategoryCellView: View {
    
    let category: Category
    
    var body: some View {
        HStack {
            AsyncImage(url: category.image) { img in
                img.resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            } placeholder: {
                ImagePlaceholderView()
            }
            
            Text(category.name)  
        }
    }
}

#Preview {
    NavigationStack {
        CategoryListScreen()
    }.environment(PlatziStore(httpClient: MockHTTPClient.preview))
}

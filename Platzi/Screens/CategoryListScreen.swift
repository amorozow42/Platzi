//
//  CategoryListScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/19/25.
//

import SwiftUI

struct CategoryListScreen: View {
    
    @Environment(PlatziStore.self) private var store
    @State private var loadingState: LoadingState<[Category]> = .loading
    @State private var showAddCategoryScreen: Bool = false
    
    var body: some View {
        ZStack {
            switch loadingState {
            case .loading:
                ProgressView("Loading...")
            case .success:
                List(store.categories) { category in
                    NavigationLink {
                        ProductListScreen(category: category)
                            .navigationTitle(category.name)
                    } label: {
                        CategoryCellView(category: category)
                    }
                }
            case .failure(let error):
                Text(error)
                    .foregroundStyle(.red)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Category") {
                    showAddCategoryScreen = true
                }
            }
        })
        .sheet(isPresented: $showAddCategoryScreen, content: {
            AddCategoryScreen()
        })
        .task {
            do {
                try await store.loadCategories()
                loadingState = .success(store.categories)
               // loadingState = .success
            } catch {
                //loadingState = .failure(error.localizedDescription)
            }
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
    }.environment(PlatziStore(httpClient: .development))
}

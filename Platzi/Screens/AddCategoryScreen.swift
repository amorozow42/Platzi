//
//  AddCategoryScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 8/6/25.
//

import SwiftUI

struct AddCategoryScreen: View {
    
    @Environment(PlatziStore.self) private var store
    @State private var name: String = ""
    @State private var isLoading: Bool = false
    
    private var isFormValid: Bool {
        !name.isEmptyOrWhitespace
    }
    
    private func createCategory() async {
        
        defer { isLoading = false }
        
        do {
            isLoading = true
            try await store.createCategory(name: name)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task { await createCategory() }
                }.disabled(isLoading || !isFormValid)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddCategoryScreen()
    }.environment(PlatziStore(httpClient: .development))
}

import SwiftUI

struct AddProductScreen: View {
    @State private var title: String = ""
    @State private var price: Double?
    @State private var description: String = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(PlatziStore.self) private var store
    
    let onSave: (Product) -> Void
    
    @State private var selectedCategoryId: Int
        
    init(selectedCategoryId: Int, onSave: @escaping (Product) -> Void) {
        self.selectedCategoryId = selectedCategoryId
        self.onSave = onSave
    }
    
    private func loadCategories() async {
        do {
            try await store.loadCategories()
            print(store.categories)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveProduct() async {
        
        guard let price = price else {
            return
        }
        
        do {
            
            let newProduct = try await store.saveProduct(title: title, price: price, description: description, categoryId: selectedCategoryId, images: [URL(string: "https://placehold.co/600x400")!])
            
            onSave(newProduct)
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && !description.isEmptyOrWhitespace && price != nil && price! > 0
    }
    
    var body: some View {
        Form {
            Picker("Select a category", selection: $selectedCategoryId) {
                ForEach(store.categories) { category in
                    Text(category.name)
                        .tag(category.id)
                }
            }.pickerStyle(.automatic)
            TextField("Title", text: $title)
            TextField("Price", value: $price, format: .number)
                .keyboardType(.decimalPad)
            TextEditor(text: $description)
                .frame(height: 100)
        }
        .task {
            await loadCategories()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save Product") {
                    Task { await saveProduct() }
                }.disabled(!isFormValid)
            }
        })
        .navigationTitle("Add Product")
    }
}

#Preview {
    NavigationStack {
        AddProductScreen(selectedCategoryId: 1, onSave: { _ in }) 
    }.environment(PlatziStore(httpClient: .development))
}

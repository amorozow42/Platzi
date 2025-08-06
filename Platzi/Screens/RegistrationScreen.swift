import SwiftUI

struct RegistrationScreen: View {
    
    private struct RegistrationForm {
        var name: String = "John Doe"
        var email: String = "johndoe@gmail.com"
        var password: String = "password1234"
        
        var isValid: Bool {
            validate().isEmpty
        }
        
        func validate() -> [String] {
            var errors: [String] = []
            
            if name.isEmptyOrWhitespace {
                errors.append("Name cannot be empty.")
            }
            if email.isEmptyOrWhitespace {
                errors.append("Email cannot be empty.")
            }
            if password.isEmptyOrWhitespace {
                errors.append("Password cannot be empty.")
            }
            if !password.isValidPassword {
                errors.append("Password must be at least 8 characters long.")
            }
            if !email.isEmail {
                errors.append("Email must be in correct format.")
            }
            
            return errors
        }
    }
    
    @State private var registrationForm = RegistrationForm()
    @State private var messageText: String?
    @State private var errors: [String] = []
    
    @Environment(\.authenticationController) private var authenticationController
    
    private func register() async {
        do {
            let response = try await authenticationController.register(
                name: registrationForm.name,
                email: registrationForm.email,
                password: registrationForm.password
            )
            messageText = "✅ Registration for user \(response.name) is completed."
        } catch {
            messageText = "❌ \(error.localizedDescription)"
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Personal Info").foregroundColor(.blue)) {
                TextField("Name", text: $registrationForm.name)
                    .foregroundColor(.primary)
                TextField("Email", text: $registrationForm.email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .foregroundColor(.primary)
                SecureField("Password", text: $registrationForm.password)
                    .textInputAutocapitalization(.never)
                    .foregroundColor(.primary)
            }
            
            Section {
                Button(action: {
                    Task {
                        errors = registrationForm.validate()
                        if errors.isEmpty {
                            await register()
                        }
                    }
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(registrationForm.isValid ? Color.blue : Color.gray)
                        .cornerRadius(8)
                }
                .listRowBackground(Color.clear)
                .disabled(!registrationForm.isValid)
            }
            
            if !errors.isEmpty {
                Section(header: Text("Please fix the following").foregroundColor(.red)) {
                    ValidationSummaryView(errors: errors)
                }
            }
            
            if let messageText {
                Section {
                    Text(messageText)
                        .foregroundColor(messageText.contains("❌") ? .red : .green)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .navigationTitle("Registration")
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        RegistrationScreen()
    }
}

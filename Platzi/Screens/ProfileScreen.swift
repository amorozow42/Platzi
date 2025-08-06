import SwiftUI

struct ProfileScreen: View {
    
    @Environment(\.authenticationController) private var authenticationController
    
    var body: some View {
        VStack(spacing: 24) {
            
            // Profile Image Placeholder
            ImagePlaceholderView(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.top, 40)

            // Name and Email
            VStack(spacing: 4) {
                Text("John Doe")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("john.doe@example.com")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Sign Out Button
            Button(action: {
                authenticationController.signOut()
            }) {
                Text("Sign Out")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        ProfileScreen()
    }
}
